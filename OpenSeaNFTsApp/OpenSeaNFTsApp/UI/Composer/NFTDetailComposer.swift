//
//  NFTDetailComposer.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/3.
//

import Foundation

final class NFTDetailComposer {
    private init() { }
    
    static func compose(model: NFTInfoModel) -> NFTDetailsViewController {
        let viewModel = NFTDetailsViewModel(model: model)
        let viewController = NFTDetailsViewController(viewModel: viewModel)
        return viewController
    }
}
