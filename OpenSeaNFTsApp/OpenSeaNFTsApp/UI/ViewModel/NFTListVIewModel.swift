//
//  NFTListVIewModel.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import Foundation
import OpenSeaNFTs
import RxSwift
import RxRelay
import web3swift
import Web3Core
import BigInt

class NFTListViewModel {
    
    private let loader: NFTsLoader
    private let ethBalanceLoader: ETHBalanceLoader
    private var next: String?
    private var isRefresh = false
    private var isLoading = false
    private var isAllLoaded = false
    
    // MARK: Output
    let isRefreshing = PublishRelay<Bool>()
    let isNextLoading = PublishRelay<Bool>()
    let displayModels = PublishRelay<[NFTInfoModel]>()
    let ethBalanceModel = PublishRelay<String>()
    
    var models = [NFTInfoModel]()
    
    // MARK: Input
    let refreshModels = PublishRelay<Void>()
    let loadNextPageModels = PublishRelay<Void>()
    let loadBalanceModel = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(loader: NFTsLoader, ethBalanceLoader: ETHBalanceLoader) {
        self.loader = loader
        self.ethBalanceLoader = ethBalanceLoader

        refreshModels.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            self.refresh()
        }.disposed(by: disposeBag)
        
        loadNextPageModels.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            self.loadNextPage()
        }.disposed(by: disposeBag)
        
        loadBalanceModel.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            self.loadETHBalance()
        }.disposed(by: disposeBag)
    }
    
    typealias LoadCompletion = () -> Void
    
    func refresh() {
        models.removeAll()
        next = nil
        isRefresh = true
        isAllLoaded = false
        loadNextPage()
    }
    
    func loadNextPage() {
        if isAllLoaded {
            return
        }
        
        if isLoading {
            return
        }
        
        isLoading = true
        if isRefresh {
            isRefreshing.accept(true)
        }
        else {
            isNextLoading.accept(true)
        }
        
        loader.load(next: next) { [weak self] result in
            guard let self = self else { return }
            
            var loadedModels = [NFTInfoModel]()
            var loadedNext: String? = nil
            
            switch result {
            case let .success((nfts, next)):
                loadedModels = nfts.map{ $0.toModel() }
                loadedNext = next
                
            case .failure:
                break
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.models.append(contentsOf: loadedModels)
                displayModels.accept(self.models)
                
                if loadedNext == nil {
                    self.isAllLoaded = true
                }
                self.next = loadedNext
                self.isLoading = false
                
                if (self.isRefresh) {
                    self.isRefresh = false
                    self.isRefreshing.accept(false)
                }
                else {
                    self.isNextLoading.accept(false)
                }
            }
        }
    }
    
    func loadETHBalance() {
        ethBalanceLoader.load { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(balanceString):
                if let value = BigUInt(from: balanceString) {
                    let balanceDisplayText = Utilities.formatToPrecision(value, formattingDecimals: 18)
                    self.ethBalanceModel.accept("\(balanceDisplayText) ETH")
                }
                
            default:
                break
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
