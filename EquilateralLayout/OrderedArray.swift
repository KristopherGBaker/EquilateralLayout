//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2015 Bodybuilding.com. All rights reserved.
//

extension Array where Element: Comparable {
    mutating func insertInOrder(_ item: Iterator.Element) {
        if count == 0 {
            insert(item, at: 0)
            return
        }

        let index = binarySearch(forKey: item)
        insert(item, at: index)

    }

    func binarySearch(forKey k: Iterator.Element) -> Int {
        var lo = 0
        var hi = count

        while hi > lo {
            let mid = lo + (hi - lo) / 2

            if self[mid] < k {
                lo = mid + 1
            }
            else {
                hi = mid
            }
        }

        return lo
    }

    func isOrdered() -> Bool {
        for i in 1 ..< count {
            if self[i] < self[i - 1] {
                return false
            }
        }

        return true
    }
}
