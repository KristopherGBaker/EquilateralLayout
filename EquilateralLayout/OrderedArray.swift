//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2015 Bodybuilding.com. All rights reserved.
//

extension _ArrayType where Generator.Element : Comparable {
    mutating func insertInOrder(item: Generator.Element) {
        if count == 0 {
            insert(item, atIndex: 0)
            return
        }

        let index = binarySearch(forKey: item)
        insert(item, atIndex: index)

    }

    func binarySearch(forKey k: Generator.Element) -> Int {
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
        for var i = 1; i < count; i++ {
            if self[i] < self[i - 1] {
                return false
            }
        }

        return true
    }
}
