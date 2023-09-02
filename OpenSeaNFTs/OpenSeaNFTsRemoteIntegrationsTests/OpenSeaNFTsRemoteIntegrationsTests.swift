//
//  OpenSeaNFTsRemoteIntegrationsTests.swift
//  OpenSeaNFTsRemoteIntegrationsTests
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import XCTest
import OpenSeaNFTs

final class OpenSeaNFTsRemoteIntegrationsTests: XCTestCase {

    func test_load_NFTs() {
        let url = testEndpointURL()
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let loader = RemoteNFTsLoader(url: url, client: client)
        
        let exp = expectation(description: "Wait loader to complete")
        loader.load { result in
            switch result {
            case let .success((nfts, next)):
                XCTAssertEqual(nfts.count, 20)
                XCTAssertNotNil(next)
                
            default:
                XCTFail("Expect success, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_load_ETHBalance() {
        let url = testETHBalanceEndpointURL()
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let loader = RemoteETHBalanceLoader(url: url, address: account(), client: client)
        
        let exp = expectation(description: "Wait loader to complete")
        loader.load { result in
            switch result {
            case let .success((balance)):
                XCTAssertNotNil(balance)
                
            default:
                XCTFail("Expect success, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    // MARK: Helpers
    private func chain() -> String {
        return "goerli"
    }
    
    private func account() -> String {
        return "0x85fD692D2a075908079261F5E351e7fE0267dB02"
    }
    
    private func testBaseEndpointURL() -> URL {
        return URL(string: "https://testnets-api.opensea.io/v2")!
    }
    
    private func testEndpointURL() -> URL {
        let queryItem = [URLQueryItem(name: "limit", value: "20")]
        let url = testBaseEndpointURL()
        return url.appendingPathComponent("chain")
            .appendingPathComponent(chain())
            .appendingPathComponent("account")
            .appendingPathComponent(account())
            .appendingPathComponent("nfts")
            .appending(queryItems: queryItem)
    }
    
    private func testETHBalanceEndpointURL() -> URL {
        return URL(string: "https://ethereum-goerli-rpc.allthatnode.com")!
    }

}
