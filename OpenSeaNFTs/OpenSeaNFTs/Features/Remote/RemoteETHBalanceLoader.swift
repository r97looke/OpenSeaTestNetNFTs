//
//  RemoteETHBalanceLoader.swift
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

public class RemoteETHBalanceLoader: ETHBalanceLoader {
    enum LoadError: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let url: URL
    private let address: String
    private let client: HTTPClient
    
    public init(url: URL, address: String, client: HTTPClient) {
        self.url = url
        self.address = address
        self.client = client
    }
    
    public func loadETHBalance(completion: @escaping (LoadResult) -> Void) {
        let json: [String : Any] = ["jsonrpc" : "2.0",
                                    "method" : "eth_getBalance",
                                    "params" : [address, "latest"],
                                    "id":1]
        let data = try! JSONSerialization.data(withJSONObject: json)
        
        client.post(to: url, data: data) { result in
            switch result {
            case .failure:
                completion(.failure(LoadError.connectivity))
                
            case let .success((data, httpResponse)):
                guard httpResponse.statusCode == 200, !data.isEmpty, let remoteETHGetBalanceResponse = try? JSONDecoder().decode(RemoteETHGetBalanceResponse.self, from: data) else {
                    completion(.failure(LoadError.invalidData))
                    return
                }
                
                completion(.success(remoteETHGetBalanceResponse.result))
            }
        }
    }
}
