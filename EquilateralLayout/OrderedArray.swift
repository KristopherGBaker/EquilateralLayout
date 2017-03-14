//
// Created by Kristopher Baker on 11/5/15.
// Copyright (c) 2017 EmpyrealNight, LLC. All rights reserved.
//

/// Encapsulates extension methods for Arrays that have Comparable Elements.
extension Array where Element: Comparable {
    
    /**
     Inserts the specified item into the array at its sorted location.
     The array the item is being inserted into should already be sorted
     before calling this method.
     
     - Parameters:
        - item: The item to insert.
     */
    mutating func insertInOrder(_ item: Iterator.Element) {
        if count == 0 {
            insert(item, at: 0)
            return
        }

        let index = binarySearch(forItem: item)
        insert(item, at: index)
    }

    /**
     Searches for the array index that most closely matches the specified item.
     The array being search should be sorted before calling this method.
     
     - Parameters:
        - item: The value to search for.
     
     - Returns:
        The array index that most closely matches the specified item.
     */
    func binarySearch(forItem item: Iterator.Element) -> Int {
        var lo = 0
        var hi = count

        while hi > lo {
            let mid = lo + (hi - lo) / 2

            if self[mid] < item {
                lo = mid + 1
            }
            else {
                hi = mid
            }
        }

        return lo
    }

    /**
     Indicates if the array is sorted in ascending order.
     
     - Returns:
        true if the array is sorted in ascending order, false otherwise.
     */
    var isOrdered: Bool {
        guard count > 1 else {
            return true
        }
        
        for i in 1 ..< count {
            if self[i] < self[i - 1] {
                return false
            }
        }

        return true
    }
}
