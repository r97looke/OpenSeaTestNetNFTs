//
//  ETHBalanceLoader.swift
//  OpenSeaNFTs
//
//  Created by Shun Lung Chen on 2023/9/2.
//

import Foundation

public protocol ETHBalanceLoader {
    typealias LoadResult = Swift.Result<String, Error>
    
    func load(completion: @escaping (LoadResult) -> Void)
}
