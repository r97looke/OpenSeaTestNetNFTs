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
import RxCocoa
import web3swift
import Web3Core
import BigInt

final class NFTListViewModel {
    
    let title = "List"
    private var next: String?
    private var isRefresh = false
    private var isLoading = false
    private var isAllLoaded = false
    
    private var models = [NFTInfoModel]()
    
    // MARK: Output
    let isRefreshing = PublishRelay<Bool>()
    let isNextLoading = PublishRelay<Bool>()
    let nftInfoModels = PublishRelay<[NFTInfoModel]>()
    let isListEmpty = PublishRelay<Bool>()
    let ethBalanceModel = PublishRelay<String>()
    
    // MARK: Input
    let refreshModels = PublishRelay<Void>()
    let loadNextPageModels = PublishRelay<Void>()
    let loadBalanceModel = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    private let loader: NFTsLoader
    private let ethBalanceLoader: ETHBalanceLoader
    
    init(loader: NFTsLoader, ethBalanceLoader: ETHBalanceLoader) {
        self.loader = loader
        self.ethBalanceLoader = ethBalanceLoader
        
        bind()
    }
    
    private func bind() {
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
    
    private func refresh() {
        if isLoading {
            return
        }
        
        next = nil
        isRefresh = true
        isAllLoaded = false
        loadNextPage()
    }
    
    private func loadNextPage() {
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
        
        let beforeLoadNext = next
        loader.load(next: next) { [weak self] result in
            guard let self = self else { return }
            
            var success = false
            var loadedModels = [NFTInfoModel]()
            var loadedNext: String? = beforeLoadNext
            
            switch result {
            case let .success((nfts, next)):
                success = true
                loadedModels = nfts.map{ $0.toModel() }
                loadedNext = next
                
            case .failure:
                break
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if (self.isRefresh) {
                    self.models.removeAll()
                }
                
                if success {
                    self.models.append(contentsOf: loadedModels)
                    nftInfoModels.accept(self.models)
                }
                else if self.models.isEmpty {
                    nftInfoModels.accept(self.models)
                }
                isListEmpty.accept(self.models.isEmpty)
                
                if success, loadedNext == nil {
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
    
    private func loadETHBalance() {
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
