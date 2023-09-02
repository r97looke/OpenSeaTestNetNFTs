//
//  HTTPClientSpy.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/2.
//

import Foundation
import OpenSeaNFTs

class HTTPClientSpy: HTTPClient {
    var requestURLs = [URL]()
    var completions = [(GETResult) -> Void]()
    
    var postRequestURLs = [URL]()
    var postCompletions = [(POSTResult) -> Void]()
    
    func get(from url: URL, completion: @escaping (GETResult) -> Void) {
        requestURLs.append(url)
        completions.append(completion)
    }
    
    func post(to url: URL, data: Data, completion: @escaping (POSTResult) -> Void) {
        postRequestURLs.append(url)
        postCompletions.append(completion)
    }
    
    func completeWith(error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func completeWith(statusCode: Int, data: Data, at index: Int = 0) {
        completions[index](.success((data, HTTPURLResponse(url: requestURLs[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!)))
    }
    
    func postCompleteWith(error: Error, at index: Int = 0) {
        postCompletions[index](.failure(error))
    }
    
    func postCompleteWith(statusCode: Int, data: Data, at index: Int = 0) {
        postCompletions[index](.success((data, HTTPURLResponse(url: postRequestURLs[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!)))
    }
}
