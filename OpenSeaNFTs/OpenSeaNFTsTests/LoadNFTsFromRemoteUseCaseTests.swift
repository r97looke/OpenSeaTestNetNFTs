//
//  LoadNFTsFromRemoteUseCaseTests.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import XCTest

protocol HTTPClient {
    func get(from url: URL)
}

class RemoteNFTsLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(next: String? = nil) {
        client.get(from: url)
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
        
        sut.load()
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    // MARK: Helpers
    private class HTTPClientSpy: HTTPClient {
        var requestURLs = [URL]()
        
        func get(from url: URL) {
            requestURLs.append(url)
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://www.any-url.com")!
    }

}
