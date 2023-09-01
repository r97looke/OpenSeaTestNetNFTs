//
//  HTTPClient.swift
//  OpenSeaNFTs
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import Foundation

public protocol HTTPClient {
    typealias GETResult = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (GETResult) -> Void)
}
