//
//  NFTDetailComposer.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/3.
//

import Foundation

final class NFTDetailComposer {
    private init() { }
    
    static func compose(model: NFTInfoModel, permalinkSelection: @escaping (NFTInfoModel) -> Void) -> NFTDetailsViewController {
        let viewModel = NFTDetailsViewModel(model: model)
        let viewController = NFTDetailsViewController(viewModel: viewModel,
                                                      permalinkSelection: permalinkSelection)
        return viewController
    }
}
