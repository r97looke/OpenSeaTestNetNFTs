//
//  NFTListViewController.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import UIKit
import SnapKit

final class NFTListViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: NFTListViewModel
    
    init(viewModel: NFTListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let DefaultMargin: CGFloat = 16.0
    private let DefaultSpace: CGFloat = 8.0
    private let refreshView = UIActivityIndicatorView(style: .large)
    private var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        title = viewModel.title
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = NFTInfoCell.DefaultSize
        layout.minimumLineSpacing = DefaultSpace
        layout.minimumInteritemSpacing = DefaultSpace
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .lightGray
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(DefaultMargin)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(DefaultMargin)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-DefaultMargin)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-DefaultMargin)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(NFTInfoCell.self, forCellWithReuseIdentifier: "\(type(of: NFTInfoCell.self))")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        refresh()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        NSLog("TODO: viewWillTransition size = \(size)")
        coordinator.animate { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func refresh() {
        viewModel.refresh { [weak self] in
            guard let self = self else { return }
            
            self.collectionView.reloadData()
        }
        collectionView.reloadData()
    }

}

// MARK: Helpers
extension NFTListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.models[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(type(of: NFTInfoCell.self))", for: indexPath) as! NFTInfoCell
        cell.model = model
        return cell
    }
}

// MARK: Helpers
extension NFTListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.size.width
        let cellWidth = floor((collectionWidth - DefaultSpace)/2.0)
        NSLog("TODO: sizeForItemAt \(indexPath) size = \(CGSize(width: cellWidth, height: NFTInfoCell.DefaultSize.height))")
        return CGSize(width: cellWidth, height: NFTInfoCell.DefaultSize.height)
    }
}
