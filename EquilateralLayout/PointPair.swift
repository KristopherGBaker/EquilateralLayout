//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2017 EmpyrealNight, LLC. All rights reserved.
//

import Foundation

struct PointPair: Comparable, Hashable {

    init() {
    }

    init(first: DirectedPoint, second: DirectedPoint) {
        self.first = first
        self.second = second
        updateHash()
    }

    var first: DirectedPoint = DirectedPoint(point: CGPoint.zero, scrollDirection: .horizontal) {
        didSet {
            updateHash()
        }
    }

    var second: DirectedPoint = DirectedPoint(point: CGPoint.zero, scrollDirection: .horizontal) {
        didSet {
            updateHash()
        }
    }

    private mutating func updateHash() {
        let key = "\(first.point.x),\(first.point.y),\(second.point.x),\(second.point.y)"
        hashValue = key.hashValue
    }

    private (set) var hashValue: Int = "0.0,0.0,0.0,0.0".hashValue

    var scrollDirection: UICollectionViewScrollDirection = .horizontal

    private static let equilateralRotationAngle = CGFloat(M_PI/3.0)

    // generates both points that form equilateral triangles with first and second
    func equilateralPoints() -> PointPair {
        let translateTransform = CGAffineTransform(translationX: second.point.x, y: second.point.y)
        let rotationTransform = CGAffineTransform(rotationAngle: PointPair.equilateralRotationAngle);
        let customRotation = translateTransform.inverted().concatenating(rotationTransform).concatenating(translateTransform);
        let p3 = CGPoint(x: first.point.x, y: first.point.y).applying(customRotation);

        let rotationTransform2 = CGAffineTransform(rotationAngle: -PointPair.equilateralRotationAngle);
        let customRotation2 = translateTransform.inverted().concatenating(rotationTransform2).concatenating(translateTransform);
        let p4 = CGPoint(x: first.point.x, y: first.point.y).applying(customRotation2);

        let d1 = DirectedPoint(point: .roundedPoint(x: p3.x, y: p3.y), scrollDirection: first.scrollDirection)
        let d2 = DirectedPoint(point: .roundedPoint(x: p4.x, y: p4.y), scrollDirection: first.scrollDirection)

        return PointPair(first: d1, second: d2)
    }
}

func ==(lhs: PointPair, rhs: PointPair) -> Bool {
    return ((lhs.first == rhs.first && lhs.second == rhs.second) ||
            (lhs.first == rhs.second && lhs.second == rhs.first)) &&
            (lhs.scrollDirection == rhs.scrollDirection)
}

func <(lhs: PointPair, rhs: PointPair) -> Bool {
    if lhs.first.scrollDirection == .horizontal {
        return (lhs.first.point.x + lhs.second.point.x) < (rhs.first.point.x + rhs.second.point.x)
    }
    else {
        return (lhs.first.point.y + lhs.second.point.y) < (rhs.first.point.y + rhs.second.point.y)
    }
}
