//
//  NFTListViewController.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NFTListViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: NFTListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: NFTListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let DefaultMargin: CGFloat = 16.0
    private let DefaultSpace: CGFloat = 8.0
    
    private var collectionView: UICollectionView!
    private let refreshView = UIActivityIndicatorView(style: .large)
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        super.loadView()
        
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = NFTInfoCell.DefaultSize
        layout.minimumLineSpacing = DefaultSpace
        layout.minimumInteritemSpacing = DefaultSpace
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(DefaultMargin)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(DefaultMargin)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-DefaultMargin)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-DefaultMargin)
        }
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.color = .brown
        view.addSubview(refreshView)
        refreshView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .blue
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.bottom.equalTo(collectionView).offset(-DefaultMargin)
            make.centerX.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.ethBalanceModel.bind(to: self.rx.title).disposed(by: disposeBag)
        
        viewModel.isRefreshing.bind(to: refreshView.rx.isAnimating).disposed(by: disposeBag)
        viewModel.isNextLoading.bind(to: loadingView.rx.isAnimating).disposed(by: disposeBag)
        
        collectionView.delegate = self
        collectionView.register(NFTInfoCell.self, forCellWithReuseIdentifier: "\(type(of: NFTInfoCell.self))")
        viewModel.displayModels.bind(to: collectionView.rx.items(cellIdentifier: "\(type(of: NFTInfoCell.self))", cellType: NFTInfoCell.self)) { (item, model, cell) in
            cell.model = model
        }.disposed(by: disposeBag)
        collectionView.rx.observe(CGRect.self, "bounds").subscribe { [weak self] _ in
            guard let self = self else { return }
            
            self.collectionView.collectionViewLayout.invalidateLayout()
        }.disposed(by: disposeBag)
        collectionView.rx.willDisplayCell.subscribe { [weak self] cell, indexPath in
            guard let self = self else { return }

            if indexPath.item + 1 == self.collectionView.numberOfItems(inSection: 0) {
                self.viewModel.loadNextPageModels.accept(Void())
            }
        }.disposed(by: disposeBag)
        collectionView.rx.modelSelected(NFTInfoModel.self).subscribe { [weak self] model in
            guard let self = self else { return }
            
            self.showDetail(model)
        }.disposed(by: disposeBag)
        
        loadBalance()
        refresh()
    }
    
    private func loadBalance() {
        viewModel.loadBalanceModel.accept(Void())
    }
    
    private func refresh() {
        viewModel.refreshModels.accept(Void())
    }
    
    private func showDetail(_ model: NFTInfoModel) {
        let detailVC = NFTDetailsViewController(model: model)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: Helpers
extension NFTListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.size.width
        let cellWidth = floor((collectionWidth - DefaultSpace)/2.0)
        return CGSize(width: cellWidth, height: NFTInfoCell.DefaultSize.height)
    }
}
