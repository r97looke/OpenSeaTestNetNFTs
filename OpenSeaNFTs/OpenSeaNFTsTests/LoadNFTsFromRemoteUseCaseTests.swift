//
//  LoadNFTsFromRemoteUseCaseTests.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import XCTest
import OpenSeaNFTs

protocol HTTPClient {
    typealias GETResult = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (GETResult) -> Void)
}

protocol NFTsLoader {
    typealias LoadResult = Swift.Result<[NFTInfo], Error>
    
    func load(next: String?, completion: @escaping (LoadResult) -> Void)
}

class RemoteNFTsLoader: NFTsLoader {
    typealias LoadResult = Swift.Result<[NFTInfo], Error>
    
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(next: String? = nil, completion: @escaping (LoadResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            default:
                break
            }
        }
    }
}

final class LoadNFTsFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteNFTsLoader(url: anyURL(), client: client)
        
        XCTAssertEqual(client.requestURLs, [])
    }
    
    func test_load_doesRequestsDataFromURL() {
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = RemoteNFTsLoader(url: url, client: client)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = RemoteNFTsLoader(url: url, client: client)
        
        let exp = expectation(description: "Wait load to complete")
        var receivedError: Error?
        sut.load { result in
            switch result {
            case let .failure(error):
                receivedError = error
                
            default:
                XCTFail("Expect error, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.completeWith(error: anyNSError())
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(receivedError)
    }
    
    // MARK: Helpers
    private class HTTPClientSpy: HTTPClient {
        var requestURLs = [URL]()
        var completions = [(GETResult) -> Void]()
        
        func get(from url: URL, completion: @escaping (GETResult) -> Void) {
            requestURLs.append(url)
            completions.append(completion)
        }
        
        func completeWith(error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://www.any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: -1)
    }

}
