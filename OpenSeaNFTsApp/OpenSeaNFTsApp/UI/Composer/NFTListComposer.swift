//
//  NFTListComposer.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/3.
//

import Foundation
import OpenSeaNFTs

final class NFTListComposer {
    
    private init() { }
    
    static func compose(nftLoader: NFTsLoader,
                        ethBalanceLoader: ETHBalanceLoader,
                        selection: @escaping (NFTInfoModel) -> Void) -> NFTListViewController {
        let viewModel = NFTListViewModel(loader: nftLoader, ethBalanceLoader: ethBalanceLoader)
        let viewController = NFTListViewController(viewModel: viewModel, selection: selection)
        return viewController
    }
}
