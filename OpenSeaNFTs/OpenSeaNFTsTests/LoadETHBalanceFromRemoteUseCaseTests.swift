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
        
        sut.loadETHBalance() { _ in }
        
        XCTAssertEqual(client.postRequestURLs, [url])
    }

    // MARK: Helpers
    private func makeSUT(_ url: URL, file: StaticString = #filePath, line: UInt = #line) -> (client: HTTPClientSpy, sut: RemoteETHBalanceLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteETHBalanceLoader(url: url, address: testAddress(), client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (client, sut)
    }
    
    private func testAddress() -> String {
        return "0x85fD692D2a075908079261F5E351e7fE0267dB02"
    }
}
