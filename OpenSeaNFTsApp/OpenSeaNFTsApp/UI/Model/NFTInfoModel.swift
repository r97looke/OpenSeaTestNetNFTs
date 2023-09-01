//
//  NFTInfoModel.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/2.
//

import Foundation

public struct NFTInfoModel: Equatable {
    public let identifier: String
    public let collection: String
    public let contract: String
    public let name: String
    public let description: String
    public let image_url: String
    
    public init(identifier: String, collection: String, contract: String, name: String, description: String, image_url: String) {
        self.identifier = identifier
        self.collection = collection
        self.contract = contract
        self.name = name
        self.description = description
        self.image_url = image_url
    }
}
