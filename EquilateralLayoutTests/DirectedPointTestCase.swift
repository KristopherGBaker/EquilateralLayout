//
//  DirectedPointTestCase.swift
//  EquilateralLayout
//
//  Created by Kris Baker on 3/13/17.
//  Copyright © 2017 Kris Baker. All rights reserved.
//

@testable import EquilateralLayout
import XCTest

class DirectedPointTestCase: XCTestCase {
    
    func testInit() {
        let directedPoint = DirectedPoint()
        XCTAssertEqual(directedPoint.point, .zero)
        XCTAssertEqual(directedPoint.scrollDirection, .horizontal)
    }
    
    func testInitValues() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        XCTAssertEqual(directedPoint.point, CGPoint(x: 3.14, y: 2.72))
        XCTAssertEqual(directedPoint.scrollDirection, .vertical)
    }
    
    func testDefaultHashValue() {
        let directedPoint = DirectedPoint()
        let hashValue = directedPoint.hashValue
        XCTAssertEqual(hashValue, "\(directedPoint.point.x),\(directedPoint.point.y)".hashValue)
    }
    
    func testHashValue() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let hashValue = directedPoint.hashValue
        XCTAssertEqual(hashValue, "\(directedPoint.point.x),\(directedPoint.point.y)".hashValue)
    }
    
    func testEqualVertical() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let directedPoint2 = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        XCTAssertEqual(directedPoint, directedPoint2)
    }
    
    func testNotEqual() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let directedPoint2 = DirectedPoint(point: CGPoint(x: 3.13, y: 2.72), scrollDirection: .vertical)
        XCTAssertNotEqual(directedPoint, directedPoint2)
    }
    
    func testEqualHorizontal() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .horizontal)
        let directedPoint2 = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .horizontal)
        XCTAssertEqual(directedPoint, directedPoint2)
    }
    
    func testNotEqualDirection() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let directedPoint2 = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .horizontal)
        XCTAssertNotEqual(directedPoint, directedPoint2)
    }
    
    func testLessThanHorizontal() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.13, y: 2.73), scrollDirection: .horizontal)
        let directedPoint2 = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .horizontal)
        XCTAssertLessThan(directedPoint, directedPoint2)
    }
    
    func testLessThanVertical() {
        let directedPoint = DirectedPoint(point: CGPoint(x: 3.15, y: 2.71), scrollDirection: .vertical)
        let directedPoint2 = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        XCTAssertLessThan(directedPoint, directedPoint2)
    }
}
