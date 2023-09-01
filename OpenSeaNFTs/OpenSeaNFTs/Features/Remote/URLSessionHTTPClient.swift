//
//  URLSessionHTTPClient.swift
//  OpenSeaNFTs
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private struct InvalidDataResponseErrorCombination: Swift.Error { }
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (GETResult) -> Void) {
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let clientError = error {
                completion(.failure(clientError))
            }
            else if let data = data, let httpURLResponse = response as? HTTPURLResponse {
                completion(.success((data, httpURLResponse)))
            }
            else {
                completion(.failure(InvalidDataResponseErrorCombination()))
            }
        }.resume()
    }
}
