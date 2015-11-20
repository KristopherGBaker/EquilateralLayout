//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2015 Bodybuilding.com. All rights reserved.
//

import CoreGraphics
import UIKit

struct DirectedPoint: Comparable, Hashable {
    var point: CGPoint = CGPointZero {
        didSet {
            updateHash()
        }
    }
    var scrollDirection: UICollectionViewScrollDirection = .Horizontal

    init() {

    }

    init(point: CGPoint, scrollDirection: UICollectionViewScrollDirection) {
        self.point = point
        self.scrollDirection = scrollDirection
        updateHash()
    }

    private mutating func updateHash() {
        let key = "\(point.x),\(point.y)"
        hashValue = key.hashValue
    }

    private (set) var hashValue: Int = "0.0,0.0".hashValue
}

internal func ==(lhs: DirectedPoint, rhs: DirectedPoint) -> Bool {
    return (lhs.point == rhs.point) &&
            (lhs.scrollDirection == rhs.scrollDirection)
}

internal func <(lhs: DirectedPoint, rhs: DirectedPoint) -> Bool {
    if lhs.scrollDirection == .Horizontal {
        return lhs.point.x < rhs.point.x
    }
    else {
        return lhs.point.y < rhs.point.y
    }
}
