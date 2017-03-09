//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2015 Bodybuilding.com. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    static func roundedPoint(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: round(x), y: round(y))
    }

    func rounded() -> CGPoint {
        return CGPoint.roundedPoint(x: x, y: y)
    }
}
