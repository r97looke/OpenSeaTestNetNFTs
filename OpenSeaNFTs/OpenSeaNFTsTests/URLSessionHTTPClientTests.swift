//
//  URLSessionHTTPClientTests.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import XCTest
import OpenSeaNFTs

class URLSessionHTTPClient: HTTPClient {
    private struct InvalidDataResponseErrorCombination: Swift.Error { }
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (GETResult) -> Void) {
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let clientError = error {
                completion(.failure(clientError))
            }
            else {
                completion(.failure(InvalidDataResponseErrorCombination()))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptRequests()
    }

    func test_getFromURL_doesGETRequestWithURL() {
        let url = anyURL()
        let sut = makeSUT()
        let exp = expectation(description: "Wait for complete")
        
        URLProtocolStub.requestObserver = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url, url)
            
            exp.fulfill()
        }
        
        sut.get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = anyURL()
        let error = anyNSError()
        let sut = makeSUT()
        let exp = expectation(description: "Wait for complete")
        
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
                
            default:
                XCTFail("Expect error, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnInvalidDataResponseErrorCombination() {
        let url = anyURL()
        let sut = makeSUT()
        
        XCTAssertNotNil(resultError(sut, url: url, data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultError(sut, url: url, data: nil, response: nonHTTPURLResponse(url), error: nil))
        XCTAssertNotNil(resultError(sut, url: url, data: nil, response: nonHTTPURLResponse(url), error: anyNSError()))
        XCTAssertNotNil(resultError(sut, url: url, data: nil, response: anyHTTPURLResponse(url, statusCode: 200), error: anyNSError()))
        XCTAssertNotNil(resultError(sut, url: url, data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultError(sut, url: url, data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultError(sut, url: url, data: anyData(), response: nonHTTPURLResponse(url), error: nil))
        XCTAssertNotNil(resultError(sut, url: url, data: anyData(), response: nonHTTPURLResponse(url), error: anyNSError()))
        XCTAssertNotNil(resultError(sut, url: url, data: anyData(), response: anyHTTPURLResponse(url, statusCode: 200), error: anyNSError()))
    }
    
    // MARK: Helpers
    private func makeSUT() -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private func nonHTTPURLResponse(_ url: URL) -> URLResponse {
        return URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse(_ url: URL, statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func resultError(_ sut: URLSessionHTTPClient, url: URL, data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for complete")
        
        URLProtocolStub.stub(data: data, response: response, error: error)
        var receivedError: Error?
        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                receivedError = error
                
            default:
                XCTFail("Expect error, got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    private class URLProtocolStub: URLProtocol {
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func startInterceptRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        static var requestObserver: ((URLRequest) -> Void)?
        
        private static var stub: Stub?
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let observer = URLProtocolStub.requestObserver {
                observer(request)
                client?.urlProtocolDidFinishLoading(self)
                return
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() { }
    }

}
