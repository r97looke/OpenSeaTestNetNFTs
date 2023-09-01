//
//  NFTsLoader.swift
//  OpenSeaNFTs
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import Foundation

public protocol NFTsLoader {
    typealias LoadResult = Swift.Result<[NFTInfo], Error>
    
    func load(next: String?, completion: @escaping (LoadResult) -> Void)
}
