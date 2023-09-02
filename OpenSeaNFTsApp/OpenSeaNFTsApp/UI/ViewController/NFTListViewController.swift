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
    private let selection: (NFTInfoModel) -> Void
    private let disposeBag = DisposeBag()
    private var becomeActiveDisposable: Disposable?
    
    init(viewModel: NFTListViewModel, selection: @escaping (NFTInfoModel) -> Void) {
        self.viewModel = viewModel
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    private let DefaultMargin: CGFloat = 16.0
    private let DefaultSpace: CGFloat = 8.0
    
    private var collectionView: UICollectionView!
    private var emptyLabel = UILabel()
    private let refreshView = UIActivityIndicatorView(style: .large)
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        super.loadView()
        
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = NFTInfoCell.DefaultSize
        layout.minimumLineSpacing = DefaultSpace
        layout.minimumInteritemSpacing = DefaultSpace
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundView = nil
        collectionView.backgroundColor = view.backgroundColor
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(DefaultMargin)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(DefaultMargin)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-DefaultMargin)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-DefaultMargin)
        }
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.font = .boldSystemFont(ofSize: 24)
        emptyLabel.textColor = .red
        emptyLabel.textAlignment = .center
        emptyLabel.text = "Can not get NFTs! Please try again later!"
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(DefaultMargin)
            make.trailing.equalToSuperview().offset(-DefaultMargin)
            make.centerY.equalToSuperview()
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
        
        viewModel.nftInfoModels.bind(to: collectionView.rx.items(cellIdentifier: "\(type(of: NFTInfoCell.self))", cellType: NFTInfoCell.self)) { (item, model, cell) in
            cell.model = model
        }.disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell.subscribe { [weak self] cell, indexPath in
            guard let self = self else { return }

            if indexPath.item + 1 == self.collectionView.numberOfItems(inSection: 0) {
                self.viewModel.loadNextPageModels.accept(Void())
            }
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(NFTInfoModel.self).subscribe { [weak self] model in
            guard let self = self else { return }
            
            self.selection(model)
        }.disposed(by: disposeBag)
        
        viewModel.nftInfoModels.map { !$0.isEmpty }.bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        loadBalance()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        becomeActiveDisposable = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.loadBalance()
                self.refresh()
        })
        becomeActiveDisposable?.disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        becomeActiveDisposable?.dispose()
        becomeActiveDisposable = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func loadBalance() {
        title = viewModel.title
        viewModel.loadBalanceModel.accept(Void())
    }
    
    private func refresh() {
        viewModel.refreshModels.accept(Void())
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension NFTListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.size.width
        let cellWidth = floor((collectionWidth - DefaultSpace)/2.0)
        return CGSize(width: cellWidth, height: NFTInfoCell.DefaultSize.height)
    }
}
