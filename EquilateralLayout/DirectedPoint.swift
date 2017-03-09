//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2017 EmpyrealNight, LLC. All rights reserved.
//

import Foundation

/// Represents a 2-dimensional point with a scroll direction.
struct DirectedPoint: Comparable, Hashable {
    
    /// The point.
    var point: CGPoint = .zero {
        didSet {
            updateHash()
        }
    }
    
    /// The scroll direction.
    var scrollDirection: UICollectionViewScrollDirection = .horizontal

    /// Initializes the DirectedPoint.
    init() {

    }

    init(point: CGPoint, scrollDirection: UICollectionViewScrollDirection) {
        self.point = point
        self.scrollDirection = scrollDirection
        updateHash()
    }

    fileprivate mutating func updateHash() {
        let key = "\(point.x),\(point.y)"
        hashValue = key.hashValue
    }

    fileprivate (set) var hashValue: Int = "0.0,0.0".hashValue
}

internal func ==(lhs: DirectedPoint, rhs: DirectedPoint) -> Bool {
    return (lhs.point == rhs.point) &&
            (lhs.scrollDirection == rhs.scrollDirection)
}

internal func <(lhs: DirectedPoint, rhs: DirectedPoint) -> Bool {
    if lhs.scrollDirection == .horizontal {
        return lhs.point.x < rhs.point.x
    }
    else {
        return lhs.point.y < rhs.point.y
    }
}
