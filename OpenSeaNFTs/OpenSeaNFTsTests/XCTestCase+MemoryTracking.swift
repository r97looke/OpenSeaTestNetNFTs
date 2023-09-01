//
//  XCTestCase+MemoryTracking.swift
//  OpenSeaNFTsTests
//
//  Created by Shun Lung Chen on 2023/9/1.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated. There may be a memory leak.", file: file, line: line)
        }
    }
}
