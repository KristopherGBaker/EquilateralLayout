//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2015 Bodybuilding.com. All rights reserved.
//

import CoreGraphics
import UIKit

struct PointPair: Comparable, Hashable {

    init() {
    }

    init(first: DirectedPoint, second: DirectedPoint) {
        self.first = first
        self.second = second
        updateHash()
    }

    var first: DirectedPoint = DirectedPoint(point: CGPointZero, scrollDirection: .Horizontal) {
        didSet {
            updateHash()
        }
    }

    var second: DirectedPoint = DirectedPoint(point: CGPointZero, scrollDirection: .Horizontal) {
        didSet {
            updateHash()
        }
    }

    private mutating func updateHash() {
        let key = "\(first.point.x),\(first.point.y),\(second.point.x),\(second.point.y)"
        hashValue = key.hashValue
    }

    private (set) var hashValue: Int = "0.0,0.0,0.0,0.0".hashValue

    var scrollDirection: UICollectionViewScrollDirection = .Horizontal

    private static let equilateralRotationAngle = CGFloat(M_PI/3.0)

    // generates both points that form equilateral triangles with first and second
    func equilateralPoints() -> PointPair {
        let translateTransform = CGAffineTransformMakeTranslation(second.point.x, second.point.y)
        let rotationTransform = CGAffineTransformMakeRotation(PointPair.equilateralRotationAngle);
        let customRotation = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translateTransform), rotationTransform), translateTransform);
        let p3 = CGPointApplyAffineTransform(CGPoint(x: first.point.x, y: first.point.y), customRotation);

        let rotationTransform2 = CGAffineTransformMakeRotation(-PointPair.equilateralRotationAngle);
        let customRotation2 = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translateTransform), rotationTransform2), translateTransform);
        let p4 = CGPointApplyAffineTransform(CGPoint(x: first.point.x, y: first.point.y), customRotation2);

        let d1 = DirectedPoint(point: CGPoint.roundedPoint(x: p3.x, y: p3.y), scrollDirection: first.scrollDirection)
        let d2 = DirectedPoint(point: CGPoint.roundedPoint(x: p4.x, y: p4.y), scrollDirection: first.scrollDirection)

        return PointPair(first: d1, second: d2)
    }
}

func ==(lhs: PointPair, rhs: PointPair) -> Bool {
    return ((lhs.first == rhs.first && lhs.second == rhs.second) ||
            (lhs.first == rhs.second && lhs.second == rhs.first)) &&
            (lhs.scrollDirection == rhs.scrollDirection)
}

func <(lhs: PointPair, rhs: PointPair) -> Bool {
    if lhs.first.scrollDirection == .Horizontal {
        return (lhs.first.point.x + lhs.second.point.x) < (rhs.first.point.x + rhs.second.point.x)
    }
    else {
        return (lhs.first.point.y + lhs.second.point.y) < (rhs.first.point.y + rhs.second.point.y)
    }
}
