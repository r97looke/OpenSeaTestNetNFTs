//
//  NFTDetailsViewModel.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/3.
//

import Foundation
import OpenSeaNFTs
import RxSwift
import RxRelay

struct NFTDetailsViewModel {
    
    let model: NFTInfoModel
    
    let modelCollection: BehaviorRelay<String>
    let modelName: BehaviorRelay<String>
    let modelDesciption: BehaviorRelay<String>
    let modelImageUrl: BehaviorRelay<String?>
    
    init(model: NFTInfoModel) {
        self.model = model
        
        modelCollection = BehaviorRelay(value: model.collection)
        modelName = BehaviorRelay(value: model.name)
        modelDesciption = BehaviorRelay(value: model.description)
        modelImageUrl = BehaviorRelay(value: model.image_url)
    }
}
