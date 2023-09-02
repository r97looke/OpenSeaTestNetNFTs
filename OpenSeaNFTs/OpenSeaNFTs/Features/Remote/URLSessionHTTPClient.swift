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
    
    public func post(to url: URL, data: Data, completion: @escaping (POSTResult) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        session.dataTask(with: request) { data, response, error in
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
