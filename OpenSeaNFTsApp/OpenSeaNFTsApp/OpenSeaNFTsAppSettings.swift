//
//  OpenSeaNFTsAppSettings.swift
//  OpenSeaNFTsApp
//
//  Created by Shun Lung Chen on 2023/9/3.
//

import Foundation

final class OpenSeaNFTsAppSettings {
    private init() { }
    
    private static func chain() -> String {
        return "goerli"
    }
    
    static func account() -> String {
        return "0x85fD692D2a075908079261F5E351e7fE0267dB02"
    }
    
    private static func endpointURL() -> URL {
        return URL(string: "https://testnets-api.opensea.io/v2")!
    }
    
    static func nftsEndpointURL() -> URL {
        let url = endpointURL()
        return url.appendingPathComponent("chain")
            .appendingPathComponent(chain())
            .appendingPathComponent("account")
            .appendingPathComponent(account())
            .appendingPathComponent("nfts")
            .appending(queryItems: [URLQueryItem(name: "limit", value: "20")])
    }
    
    static func ethBalanceEndpointURL() -> URL {
        return URL(string: "https://ethereum-goerli-rpc.allthatnode.com")!
    }
    
    static func permalinkBase() -> String {
        return "https://testnets.opensea.io/assets/goerli"
    }

}
