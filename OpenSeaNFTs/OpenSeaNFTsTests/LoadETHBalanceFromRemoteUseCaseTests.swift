//
//  LoadETHBalanceFromRemoteUseCaseTests.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/2.
//

import XCTest
import OpenSeaNFTs

final class LoadETHBalanceFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotPostDataToURL() {
        let (client, _) = makeSUT(anyURL())
        
        XCTAssertEqual(client.postRequestURLs, [])
    }
    
    func test_load_doesPostDataToURL() {
        let url = anyURL()
        let (client, sut) = makeSUT(url)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.postRequestURLs, [url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.connectivity)) {
            client.postCompleteWith(error: anyNSError())
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (client, sut) = makeSUT(anyURL())
        
        let sample = [100, 199, 201, 300, 400, 500]
        
        for (index, code) in sample.enumerated() {
            expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.invalidData)) {
                client.postCompleteWith(statusCode: code, data: Data(), at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInValidData() {
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.invalidData)) {
            client.postCompleteWith(statusCode: 200, data: Data("invalid data".utf8))
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithEmptyData() {
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.invalidData)) {
            client.postCompleteWith(statusCode: 200, data: Data())
        }
    }
    
    func test_load_deliversBalanceOn200HTTPResponseWithValidData() {
        let expectedBalance = testBalance()
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .success((expectedBalance))) {
            client.postCompleteWith(statusCode: 200, data: makeBalanceJSON(expectedBalance))
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocate() {
        let client = HTTPClientSpy()
        var sut: RemoteETHBalanceLoader? = RemoteETHBalanceLoader(url: anyURL(), address: testAddress(), client: client)
        
        var receivedResult: ETHBalanceLoader.LoadResult?
        sut?.load() { result in
            receivedResult = result
        }
        
        sut = nil
        client.postCompleteWith(error: anyNSError())
        XCTAssertNil(receivedResult)
    }
    
    // MARK: Helpers
    private func makeSUT(_ url: URL, file: StaticString = #filePath, line: UInt = #line) -> (client: HTTPClientSpy, sut: RemoteETHBalanceLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteETHBalanceLoader(url: url, address: testAddress(), client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (client, sut)
    }
    
    private func expect(_ sut: RemoteETHBalanceLoader, toCompleteWith expectedResult: ETHBalanceLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait load to complete")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedBalance), .success(expectedBalance)):
                XCTAssertEqual(receivedBalance, expectedBalance, file: file, line: line)
                break
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expect \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func testAddress() -> String {
        return "0x85fD692D2a075908079261F5E351e7fE0267dB02"
    }
    
    private func testBalance() -> String {
        return "0x12345"
    }
    
    private func makeBalanceJSON(_ balance: String) -> Data {
        let json: [String : Any] = ["id" : 1,
                                    "jsonrpc" : "2.0",
                                    "result" : balance]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
