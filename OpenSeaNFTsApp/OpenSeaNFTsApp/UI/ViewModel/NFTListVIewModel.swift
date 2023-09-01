//
//  NFTListVIewModel.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import Foundation
import OpenSeaNFTs

class NFTListViewModel {
    
    private let loader: NFTsLoader
    private var next: String?
    private var allLoaded = false
    
    private var isLoading = false
    
    var models = [NFTInfoModel]()
    
    init(loader: NFTsLoader) {
        self.loader = loader
    }
    
    typealias LoadCompletion = () -> Void
    
    func refresh(completion: @escaping LoadCompletion) {
        next = nil
        allLoaded = false
        models.removeAll()
        loadNextPage(completion: completion)
    }
    
    func loadNextPage(completion: @escaping LoadCompletion) {
        isLoading = true
        loader.load(next: next) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success((nextNFTs, next)):
                DispatchQueue.main.async {
                    if next == nil {
                        self.allLoaded = true
                    }
                    self.next = next
                    self.models.append(contentsOf: nextNFTs.map{ $0.toModel() })
                    self.isLoading = false
                    completion()
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion()
                }
            }
        }
    }
    
    let title = "List"
}

private extension NFTInfo {
    func toModel() -> NFTInfoModel {
        return NFTInfoModel(identifier: identifier,
                            collection: collection,
                            contract: contract,
                            name: name,
                            description: description,
                            image_url: image_url)
    }
}
