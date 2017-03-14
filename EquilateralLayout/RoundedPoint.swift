//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2017 EmpyrealNight, LLC. All rights reserved.
//

/// Encapsulates extension methods for CGPoint.
extension CGPoint {
    
    /**
     Returns the specified x and y values as a point, with the values rounded to the nearest integer.
     
     - Parameters:
        - x: The x-value.
        - y: The y-value.
     
     - Returns:
        The rounded x and y values as a point.
     */
    static func roundedPoint(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: round(x), y: round(y))
    }

    /**
     Rounds the x and y values to the nearest integer, and returns them as a point.
     
     - Returns:
        The rounded x and y values as a point.
     */
    func rounded() -> CGPoint {
        return .roundedPoint(x: x, y: y)
    }
}
