//
//  PointPairTestCase.swift
//  EquilateralLayout
//
//  Created by Kris Baker on 3/13/17.
//  Copyright © 2017 Kris Baker. All rights reserved.
//

@testable import EquilateralLayout
import XCTest

class PointPairTestCase: XCTestCase {
    
    func distance(_ first: CGPoint, _ second: CGPoint) -> CGFloat {
        let x = first.x - second.x
        let y = first.y - second.y
        return sqrt(x*x + y*y)
    }
    
    func testEquilateralPoints() {
        let first = DirectedPoint(point: CGPoint(x: 33, y: 32), scrollDirection: .vertical)
        let second = DirectedPoint(point: CGPoint(x: 43, y: 42), scrollDirection: .vertical)
        let pair = PointPair(first: first, second: second)
        let equilateralPoints = pair.equilateralPoints()
        
        let equilateralPoint1 = DirectedPoint(point: CGPoint(x: 47, y: 28), scrollDirection: .vertical)
        let equilateralPoint2 = DirectedPoint(point: CGPoint(x: 29, y: 46), scrollDirection: .vertical)
        let equilateralPoints2 = PointPair(first: equilateralPoint1, second: equilateralPoint2)
        
        XCTAssertEqual(equilateralPoints, equilateralPoints2)
        
        let d = distance(first.point, equilateralPoints.first.point)
        let d2 = distance(second.point, equilateralPoints.first.point)
        let d3 = distance(first.point, equilateralPoints.second.point)
        let d4 = distance(second.point, equilateralPoints.second.point)
        
        XCTAssertEqual(d, d2)
        XCTAssertEqual(d, d3)
        XCTAssertEqual(d, d4)
    }
    
    func testInit() {
        let pair = PointPair()
        XCTAssertEqual(pair.first.point, .zero)
        XCTAssertEqual(pair.second.point, .zero)
        XCTAssertEqual(pair.first.scrollDirection, .horizontal)
        XCTAssertEqual(pair.second.scrollDirection, .horizontal)
    }
    
    func testInitValues() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .vertical)
        let pair = PointPair(first: first, second: second)
        XCTAssertEqual(pair.first.point, CGPoint(x: 3.14, y: 2.72))
        XCTAssertEqual(pair.second.point, CGPoint(x: 5, y: 7))
        XCTAssertEqual(pair.first.scrollDirection, .vertical)
        XCTAssertEqual(pair.second.scrollDirection, .vertical)
    }
 
    func testDefaultHashValue() {
        let pair = PointPair()
        let hashValue = pair.hashValue
        XCTAssertEqual(hashValue, "\(pair.first.point.x),\(pair.first.point.y),\(pair.second.point.x),\(pair.second.point.y)".hashValue)
    }
    
    func testHashValue() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .vertical)
        let pair = PointPair(first: first, second: second)
        let hashValue = pair.hashValue
        XCTAssertEqual(hashValue, "\(pair.first.point.x),\(pair.first.point.y),\(pair.second.point.x),\(pair.second.point.y)".hashValue)
    }
    
    func testEqualVertical() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .vertical)
        let pair = PointPair(first: first, second: second)
        let pair2 = PointPair(first: first, second: second)
        XCTAssertEqual(pair, pair2)
    }
    
    func testNotEqual() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .vertical)
        let pair = PointPair(first: first, second: second)
        let pair2 = PointPair(first: second, second: second)
        XCTAssertNotEqual(pair, pair2)
    }
    
    func testEqualHorizontal() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .horizontal)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .horizontal)
        let pair = PointPair(first: first, second: second)
        let pair2 = PointPair(first: first, second: second)
        XCTAssertEqual(pair, pair2)
    }
    
    func testNotEqualDirection() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .vertical)
        let secondHorizontal = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .horizontal)
        let pair = PointPair(first: first, second: second)
        let pair2 = PointPair(first: first, second: secondHorizontal)
        XCTAssertNotEqual(pair, pair2)
    }
    
    func testLessThanHorizontal() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .horizontal)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .horizontal)
        let first2 = DirectedPoint(point: CGPoint(x: 6.14, y: 2.72), scrollDirection: .horizontal)
        let second2 = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .horizontal)
        let pair = PointPair(first: first, second: second)
        let pair2 = PointPair(first: first2, second: second2)
        XCTAssertLessThan(pair, pair2)
    }
    
    func testLessThanVertical() {
        let first = DirectedPoint(point: CGPoint(x: 3.14, y: 2.72), scrollDirection: .vertical)
        let second = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .vertical)
        let first2 = DirectedPoint(point: CGPoint(x: 3.14, y: 5.72), scrollDirection: .vertical)
        let second2 = DirectedPoint(point: CGPoint(x: 5, y: 7), scrollDirection: .vertical)
        let pair = PointPair(first: first, second: second)
        let pair2 = PointPair(first: first2, second: second2)
        XCTAssertLessThan(pair, pair2)
    }
}
