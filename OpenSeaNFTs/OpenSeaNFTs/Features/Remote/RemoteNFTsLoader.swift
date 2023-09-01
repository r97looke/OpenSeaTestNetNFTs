//
//  RemoteNFTsLoader.swift
//  OpenSeaNFTs
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import Foundation

public class RemoteNFTsLoader: NFTsLoader {
    public enum LoadError: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(next: String? = nil, completion: @escaping (LoadResult) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let next = next {
            urlComponents.queryItems = [URLQueryItem(name: "limit", value: "20"),
                                        URLQueryItem(name: "next", value: next)]
        }
        else {
            urlComponents.queryItems = [URLQueryItem(name: "limit", value: "20")]
        }
        
        let updatedURL = urlComponents.url!
        client.get(from: updatedURL) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .failure:
                completion(.failure(LoadError.connectivity))
                
            case let .success((data, httpURLResponse)):
                guard httpURLResponse.statusCode == 200, !data.isEmpty, let remoteNFTResponse = try? JSONDecoder().decode(RemoteNFTResponse.self, from: data) else {
                    completion(.failure(LoadError.invalidData))
                    return
                }
                
                completion(.success((remoteNFTResponse.nfts.map{ $0.toModel() }, remoteNFTResponse.next)))
            }
        }
    }
}

// MARK: - Helpers
private extension RemoteNFTInfo {
    func toModel() -> NFTInfo {
        return NFTInfo(identifier: identifier,
                       collection: collection,
                       contract: contract,
                       name: name,
                       description: description,
                       image_url: image_url)
    }
}
