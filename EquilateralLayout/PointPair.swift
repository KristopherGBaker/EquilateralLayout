//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2017 EmpyrealNight, LLC. All rights reserved.
//

/// Represents a pair of directed points.
struct PointPair: Hashable {

    /// The hash value.
    private (set) var hashValue: Int = "0.0,0.0,0.0,0.0".hashValue
    
    /// The first point in the pair.
    var first: DirectedPoint = DirectedPoint(point: .zero, scrollDirection: .horizontal) {
        didSet {
            updateHash()
        }
    }
    
    /// The second point in the pair.
    var second: DirectedPoint = DirectedPoint(point: .zero, scrollDirection: .horizontal) {
        didSet {
            updateHash()
        }
    }
    
    /// Creates a PointPair with first location (0, 0), second location (0, 0), and horizontal scroll direction.
    init() {
        
    }

    /**
     Creates a PointPair with the specified points.
     
     - Parameters:
        - first: The first point in the pair.
        - second: The second point in the pair.
     */
    init(first: DirectedPoint, second: DirectedPoint) {
        self.first = first
        self.second = second
        updateHash()
    }

    /// Updates the hash value.
    private mutating func updateHash() {
        let key = "\(first.point.x),\(first.point.y),\(second.point.x),\(second.point.y)"
        hashValue = key.hashValue
    }
}

/// The rotation angle for constructing equilateral triangles.
fileprivate let EquilateralRotationAngle = CGFloat(M_PI/3.0)

/// Provides methods for generating equilateral triangle points.
extension PointPair {
    
    /// Generates both points that form equilateral triangles with first and second.
    func equilateralPoints() -> PointPair {
        let translateTransform = CGAffineTransform(translationX: second.point.x, y: second.point.y)
        let rotationTransform = CGAffineTransform(rotationAngle: EquilateralRotationAngle)
        let customRotation = translateTransform.inverted().concatenating(rotationTransform).concatenating(translateTransform)
        let p3 = CGPoint(x: first.point.x, y: first.point.y).applying(customRotation)
        
        let rotationTransform2 = CGAffineTransform(rotationAngle: -EquilateralRotationAngle)
        let customRotation2 = translateTransform.inverted().concatenating(rotationTransform2).concatenating(translateTransform)
        let p4 = CGPoint(x: first.point.x, y: first.point.y).applying(customRotation2)
        
        let d1 = DirectedPoint(point: .roundedPoint(x: p3.x, y: p3.y), scrollDirection: first.scrollDirection)
        let d2 = DirectedPoint(point: .roundedPoint(x: p4.x, y: p4.y), scrollDirection: first.scrollDirection)
        
        return PointPair(first: d1, second: d2)
    }
    
}

/// Implements Comparable for PointPair.
extension PointPair: Comparable {
    static func == (lhs: PointPair, rhs: PointPair) -> Bool {
        return ((lhs.first.scrollDirection == rhs.first.scrollDirection) &&
                (lhs.second.scrollDirection == rhs.second.scrollDirection) &&
                (lhs.first.scrollDirection == rhs.second.scrollDirection)) &&
               ((lhs.first == rhs.first && lhs.second == rhs.second) ||
                (lhs.first == rhs.second && lhs.second == rhs.first))
        
    }
    
    static func < (lhs: PointPair, rhs: PointPair) -> Bool {
        if lhs.first.scrollDirection == .horizontal {
            return (lhs.first.point.x + lhs.second.point.x) < (rhs.first.point.x + rhs.second.point.x)
        }
        else {
            return (lhs.first.point.y + lhs.second.point.y) < (rhs.first.point.y + rhs.second.point.y)
        }
    }
}
