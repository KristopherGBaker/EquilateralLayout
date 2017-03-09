//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2017 EmpyrealNight, LLC. All rights reserved.
//

import Foundation

extension CGPoint {
    static func roundedPoint(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: round(x), y: round(y))
    }

    func rounded() -> CGPoint {
        return .roundedPoint(x: x, y: y)
    }
}
