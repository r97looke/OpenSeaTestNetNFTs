//
//  RemoteETHGetBalanceResponse.swift
//  OpenSeaNFTs
//
//  Created by Shun Lung Chen on 2023/9/2.
//

import Foundation

struct RemoteETHGetBalanceResponse: Codable {
    let id: Int
    let jsonrpc: String
    let result: String
}
