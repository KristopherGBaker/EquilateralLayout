//
//  OrderedArrayTestCase.swift
//  EquilateralLayout
//
//  Created by Kris Baker on 3/13/17.
//  Copyright © 2017 Kris Baker. All rights reserved.
//

@testable import EquilateralLayout
import XCTest

class OrderedArrayTestCase: XCTestCase {
    
    func testIsOrdered() {
        let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        XCTAssertTrue(values.isOrdered)
    }
    
    func testIsNotOrdered() {
        let values = [1, 2, 3, 4, 10, 5, 9, 6, 8, 7]
        XCTAssertFalse(values.isOrdered)
    }
    
    func testEmptyIsOrdered() {
        let values: [Int] = []
        XCTAssertTrue(values.isOrdered)
    }
    
    func testSingleIsOrdered() {
        let values: [Int] = [1]
        XCTAssertTrue(values.isOrdered)
    }
    
    func testRepeatingValuesIsOrdered() {
        let values = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
        XCTAssertTrue(values.isOrdered)
    }
    
    func testInsertInOrder() {
        var values: [UInt32] = []
        
        for _ in 0 ..< 100 {
            let val = arc4random_uniform(10)
            values.insertInOrder(val)
            XCTAssertTrue(values.isOrdered)
        }
    }
    
    func testBinarySearchEmpty() {
        let values: [Int] = []
        let searchIndex = values.binarySearch(forItem: 4)
        XCTAssertEqual(searchIndex, 0)
    }
    
    func testBinarySearch() {
        let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        // search for each item in the array, one at a time
        // the result from binary search should be the index of the item
        // since we have an ordered array with unique values
        for item in 1 ... 10 {
            let searchIndex = values.binarySearch(forItem: item)
            XCTAssertEqual(values[searchIndex], item)
        }
    }
}
