//
//  URLSessionHTTPClientTests.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import XCTest
import OpenSeaNFTs

class URLSessionHTTPClient: HTTPClient {
    
    func get(from url: URL, completion: @escaping (GETResult) -> Void) {
        
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

//    func test_getFromURL_doesGETRequestWithURL() {
//        let url = anyURL()
//        let sut = makeSUT()
//        let exp = expectation(description: "Wait for complete")
//        
//        URLProtocolStub.requestObserver = { request in
//            XCTAssertEqual(request.httpMethod, "GET")
//            XCTAssertEqual(request.url, url)
//            
//            exp.fulfill()
//        }
//        
//        sut.get(from: url) { _ in }
//        
//        wait(for: [exp], timeout: 1.0)
//    }
//    
//    // MARK: Helpers
//    private func makeSUT() -> URLSessionHTTPClient {
//        let sut = URLSessionHTTPClient()
//        trackForMemoryLeaks(sut)
//        return sut
//    }

}
