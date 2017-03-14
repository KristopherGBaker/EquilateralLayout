//
//  RoundedPointTestCase.swift
//  EquilateralLayout
//
//  Created by Kris Baker on 3/13/17.
//  Copyright © 2017 Kris Baker. All rights reserved.
//

@testable import EquilateralLayout
import XCTest

class RoundedPointTestCase: XCTestCase {
    
    func testRounded() {
        let point = CGPoint(x: 2.14, y: 2.72)
        let rounded = point.rounded()
        XCTAssertEqual(rounded.x, 2.0)
        XCTAssertEqual(rounded.y, 3.0)
    }
    
    func testRoundedPointFive() {
        let point = CGPoint(x: 2.5, y: 3.5)
        let rounded = point.rounded()
        XCTAssertEqual(rounded.x, 3.0)
        XCTAssertEqual(rounded.y, 4.0)
    }
    
    func testStaticRounded() {
        let rounded = CGPoint.roundedPoint(x: 2.14, y: 2.72)
        XCTAssertEqual(rounded.x, 2.0)
        XCTAssertEqual(rounded.y, 3.0)
    }
    
    func testStaticRoundedPointFive() {
        let rounded = CGPoint.roundedPoint(x: 2.5, y: 3.5)
        XCTAssertEqual(rounded.x, 3.0)
        XCTAssertEqual(rounded.y, 4.0)
    }
    
}
