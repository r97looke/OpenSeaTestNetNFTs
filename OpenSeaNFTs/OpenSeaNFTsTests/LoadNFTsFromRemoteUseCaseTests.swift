//
//  LoadNFTsFromRemoteUseCaseTests.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import XCTest
import OpenSeaNFTs

final class LoadNFTsFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (client, _) = makeSUT(anyURL())
        
        XCTAssertEqual(client.requestURLs, [])
    }
    
    func test_load_doesRequestsDataFromURL() {
        let url = anyURL()
        let (client, sut) = makeSUT(url)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.connectivity)) {
            client.completeWith(error: anyNSError())
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.invalidData)) {
            client.completeWith(statusCode: 199, data: Data())
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInValidData() {
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.invalidData)) {
            client.completeWith(statusCode: 200, data: Data("invalid data".utf8))
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInEmptyData() {
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .failure(RemoteNFTsLoader.LoadError.invalidData)) {
            client.completeWith(statusCode: 200, data: Data())
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithValidData() {
        let expectedNFTs = testNFTs()
        let (client, sut) = makeSUT(anyURL())
        
        expect(sut, toCompleteWith: .success((expectedNFTs, nil))) {
            client.completeWith(statusCode: 200, data: makeNFTsJSON(expectedNFTs))
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocate() {
        let client = HTTPClientSpy()
        var sut: RemoteNFTsLoader? = RemoteNFTsLoader(url: anyURL(), client: client)
        
        var receivedResult: NFTsLoader.LoadResult?
        sut?.load() { result in
            receivedResult = result
        }
        
        sut = nil
        client.completeWith(error: anyNSError())
        XCTAssertNil(receivedResult)
    }
    
    // MARK: Helpers
    private func makeSUT(_ url: URL, file: StaticString = #filePath, line: UInt = #line) -> (client: HTTPClientSpy, sut: RemoteNFTsLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteNFTsLoader(url: url, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (client, sut)
    }
    
    private func expect(_ sut: RemoteNFTsLoader, toCompleteWith expectedResult: NFTsLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait load to complete")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success((receivedNFTs, _)), .success((expectedNFTs, _))):
                XCTAssertEqual(receivedNFTs, expectedNFTs, file: file, line: line)
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
    
    private func testNFT() -> NFTInfo {
        return NFTInfo(identifier: "id-1",
                       collection: "collection-1",
                       contract: "contract-1",
                       name: "NFT-1",
                       description: "NFT-1 description",
                       image_url: "http://www.image1.com")
    }
    
    private func testAnotherNFT() -> NFTInfo {
        return NFTInfo(identifier: "id-2",
                       collection: "collection-2",
                       contract: "contract-2",
                       name: "NFT-2",
                       description: "NFT-2 description",
                       image_url: "http://www.image2.com")
    }
    
    private func testNFTs() -> [NFTInfo] {
        return [testNFT(), testAnotherNFT()]
    }
    
    private func makeNFTsJSON(_ nfts: [NFTInfo]) -> Data {
        let remoteNFTs = nfts.map{ $0.toRemote() }
        let remoteNFTsJSON = remoteNFTs.map { $0.json() }
        let json = ["nfts" : remoteNFTsJSON]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}


private extension NFTInfo {
    func toRemote() -> RemoteNFTInfo {
        return RemoteNFTInfo(identifier: identifier,
                             collection: collection,
                             contract: contract,
                             name: name,
                             description: description,
                             image_url: image_url)
    }
}

private extension RemoteNFTInfo {
    func json() -> [String : Any] {
        return ["identifier" : identifier,
                "collection" : collection,
                "contract" : contract,
                "name" : name,
                "description" : description,
                "image_url" : image_url]
    }
}
