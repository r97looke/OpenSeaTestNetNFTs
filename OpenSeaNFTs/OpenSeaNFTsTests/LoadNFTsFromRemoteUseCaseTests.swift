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

struct RemoteNFTResponse: Codable {
    let nfts: [RemoteNFTInfo]
}

struct RemoteNFTInfo: Codable {
    let identifier: String
    let collection: String
    let contract: String
    let name: String
    let description: String
    let image_url: String
}

private extension RemoteNFTInfo {
    func toModel() -> NFTInfo {
        return NFTInfo(identifier: identifier,
                       collection: collection,
                       contract: contract,
                       name: name,
                       description: description,
                       image_url: image_url)
    }
}

class RemoteNFTsLoader: NFTsLoader {
    typealias LoadResult = Swift.Result<[NFTInfo], Error>
    
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    enum LoadError: Swift.Error {
        case connectivity
        case invalidData
    }
    
    func load(next: String? = nil, completion: @escaping (LoadResult) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                completion(.failure(LoadError.connectivity))
                
            case let .success((data, httpURLResponse)):
                guard httpURLResponse.statusCode == 200, !data.isEmpty, let remoteNFTResponse = try? JSONDecoder().decode(RemoteNFTResponse.self, from: data) else {
                    completion(.failure(LoadError.invalidData))
                    return
                }
                
                completion(.success(remoteNFTResponse.nfts.map{ $0.toModel() }))
            }
        }
    }
}

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
        
        expect(sut, toCompleteWith: .success(expectedNFTs)) {
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
    private func makeSUT(_ url: URL) -> (client: HTTPClientSpy, sut: RemoteNFTsLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteNFTsLoader(url: url, client: client)
        return (client, sut)
    }
    
    private func expect(_ sut: RemoteNFTsLoader, toCompleteWith expectedResult: NFTsLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait load to complete")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedNFTs), .success(expectedNFTs)):
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
        
        func completeWith(statusCode: Int, data: Data, at index: Int = 0) {
            completions[index](.success((data, HTTPURLResponse(url: requestURLs[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!)))
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://www.any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: -1)
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
