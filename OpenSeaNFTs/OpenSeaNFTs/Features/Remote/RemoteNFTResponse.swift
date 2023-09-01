//
//  RemoteNFTResponse.swift
//  OpenSeaNFTs
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import Foundation

public struct RemoteNFTResponse: Codable {
    public let nfts: [RemoteNFTInfo]
}
