//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2017 EmpyrealNight, LLC. All rights reserved.
//

/// Represents a 2-dimensional point with a scroll direction.
struct DirectedPoint: Hashable {
    
    /// The point.
    var point: CGPoint = .zero {
        didSet {
            updateHash()
        }
    }
    
    /// The scroll direction.
    var scrollDirection: UICollectionViewScrollDirection = .horizontal
    
    /// The hash value.
    private (set) var hashValue: Int = "0.0,0.0".hashValue

    /// Creates a DirectedPoint with location (0, 0) and horizontal scroll direction.
    init() {

    }

    /**
     Creates a DirectedPoint with the spepcified point and scroll direction.
     
     - Parameters:
        - point: The point.
        - scrollDirection: The scroll direction.
     */
    init(point: CGPoint, scrollDirection: UICollectionViewScrollDirection) {
        self.point = point
        self.scrollDirection = scrollDirection
        updateHash()
    }

    /// Updates the hash value.
    private mutating func updateHash() {
        let key = "\(point.x),\(point.y)"
        hashValue = key.hashValue
    }   
}

/// Implements Comparable for DirectedPoint.
extension DirectedPoint: Comparable {
    static func == (lhs: DirectedPoint, rhs: DirectedPoint) -> Bool {
        return (lhs.point == rhs.point) &&
               (lhs.scrollDirection == rhs.scrollDirection)
    }
    
    static func < (lhs: DirectedPoint, rhs: DirectedPoint) -> Bool {
        if lhs.scrollDirection == .horizontal {
            return lhs.point.x < rhs.point.x
        }
        else {
            return lhs.point.y < rhs.point.y
        }
    }
}
