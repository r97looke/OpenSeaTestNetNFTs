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
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func load(next: String?) {
        
    }
}

final class LoadNFTsFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteNFTsLoader(httpClient: client)
        
        XCTAssertEqual(client.requestURLs, [])
    }
    
    // MARK: Helpers
    private class HTTPClientSpy: HTTPClient {
        var requestURLs = [URL]()
        
        func get(from url: URL) {
            
        }
    }

}
