//
//  EquilateralPoints.swift
//  EquilateralLayout
//
//  Created by Kris Baker on 3/8/17.
//  Copyright © 2017 Kris Baker. All rights reserved.
//

struct EquilateralPoints {

    var scrollDirection: UICollectionViewScrollDirection = .horizontal
    
    var itemSize: CGSize = CGSize(width: 90, height: 90)
    var startingOffset: CGFloat = 80.0
    var itemSpacing: CGFloat = 8.0
    var points = [DirectedPoint]()
    
    @discardableResult
    mutating func generate(insets: UIEdgeInsets, bounds: CGRect, itemCount: Int) -> CGFloat {
        let halfWidth = itemSize.width*0.5
        let halfHeight = itemSize.height*0.5
        let p0 = scrollDirection == .horizontal ? CGPoint.roundedPoint(x: insets.left + halfWidth, y: bounds.midY) : CGPoint.roundedPoint(x: bounds.midX, y: insets.top + halfHeight)
        
        let side: CGFloat = (scrollDirection == .horizontal ? itemSize.width : itemSize.height) + itemSpacing
        
        var firstPair = PointPair()
        firstPair.first = DirectedPoint(point: p0, scrollDirection: scrollDirection)
        
        if itemCount > 1 {
            var x1: CGFloat!
            var y1: CGFloat!
            
            if scrollDirection == .horizontal {
                x1 = p0.x + startingOffset
                y1 = sqrt((side*side) - ((x1 - p0.x)*(x1 - p0.x))) + p0.y
            }
            else {
                y1 = p0.y + startingOffset
                x1 = p0.x - sqrt((side*side) - ((y1 - p0.y)*(y1 - p0.y)))
            }
            
            firstPair.second = DirectedPoint(point: CGPoint.roundedPoint(x: x1, y: y1), scrollDirection: scrollDirection)
        }
        
        let maxVal = generatePoints(firstPair, itemCount: itemCount, bounds: bounds, halfWidth: halfWidth, halfHeight: halfHeight)
        return maxVal
    }
    
    private mutating func generatePoints(_ firstPair: PointPair, itemCount: Int, bounds: CGRect, halfWidth: CGFloat, halfHeight: CGFloat) -> CGFloat {
        var pairs = [PointPair]()
        pairs.append(firstPair)
        
        var pairSet = Set<PointPair>()
        pairSet.insert(firstPair)
        
        var visited = Set<PointPair>()
        
        points.insertInOrder(firstPair.first)
        points.insertInOrder(firstPair.second)
        
        let containingRect = scrollDirection == .horizontal ? CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: bounds.height) : CGRect(x: 0, y: 0, width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        
        var maxX = firstPair.second.point.x
        var maxY = firstPair.second.point.y
        
        var pointSet = Set<DirectedPoint>()
        pointSet.insert(firstPair.first)
        pointSet.insert(firstPair.second)
        
        while points.count < itemCount && !pairs.isEmpty {
            let pair = pairs.removeFirst()
            pairSet.remove(pair)
            visited.insert(pair)
            
            let equilateralPoints = pair.equilateralPoints()
            let result = addNewPairs(containingRect, pair: pair, point: equilateralPoints.first, halfWidth: halfWidth, halfHeight: halfHeight, visited: visited)
            
            if result.contained {
                for p in result.pairs {
                    if !pairSet.contains(p) {
                        pairs.insertInOrder(p)
                        pairSet.insert(p)
                    }
                }
                
                if !pointSet.contains(equilateralPoints.first) {
                    maxX = max(maxX, equilateralPoints.first.point.x)
                    maxY = max(maxY, equilateralPoints.first.point.y)
                    points.insertInOrder(equilateralPoints.first)
                    pointSet.insert(equilateralPoints.first)
                }
            }
            
            let result2 = addNewPairs(containingRect, pair: pair, point: equilateralPoints.second, halfWidth: halfWidth, halfHeight: halfHeight, visited: visited)
            
            if result2.contained {
                for p in result2.pairs {
                    if !pairSet.contains(p) {
                        pairs.insertInOrder(p)
                        pairSet.insert(p)
                    }
                }
                
                if !pointSet.contains(equilateralPoints.second) {
                    maxX = max(maxX, equilateralPoints.second.point.x)
                    maxY = max(maxY, equilateralPoints.second.point.y)
                    points.insertInOrder(equilateralPoints.second)
                    pointSet.insert(equilateralPoints.second)
                }
            }
        }
        
        return scrollDirection == .horizontal ? maxX : maxY
    }
    
    private func addNewPairs(_ containingRect: CGRect, pair: PointPair, point: DirectedPoint, halfWidth: CGFloat, halfHeight: CGFloat, visited: Set<PointPair>) -> (pairs: [PointPair], contained: Bool) {
        if containingRect.contains(CGRect(x: point.point.x - halfWidth, y: point.point.y - halfHeight, width: itemSize.width, height: itemSize.width)) {
            var pairs = [PointPair]()
            let p0 = PointPair(first: pair.first, second: point)
            let p1 = PointPair(first: pair.second, second: point)
            
            if !visited.contains(p0) {
                pairs.append(p0)
            }
            
            if !visited.contains(p1) {
                pairs.append(p1)
            }
            
            return (pairs: pairs, contained: true)
        }
        
        return (pairs: [], contained: false)
    }
    
}
