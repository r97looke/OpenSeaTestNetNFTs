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
}
