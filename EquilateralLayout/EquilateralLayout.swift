//
//  EquilateralLayout.swift
//  Sphere
//
//  Created by Kristopher Baker on 10/29/15.
//  Copyright © 2015 Bodybuilding.com. All rights reserved.
//

import CoreGraphics
import UIKit

public class EquilateralLayout: UICollectionViewLayout {

    var scrollDirection: UICollectionViewScrollDirection = .Horizontal {
        didSet {
            resetLayout()
        }
    }
    
    var itemSize: CGSize = CGSizeMake(90, 90)
    var startingOffset: CGFloat = 80.0
    var itemSpacing: CGFloat = 8.0
    var reset: Bool = true
    
    private var points = [DirectedPoint]()
    private var contentSize: CGSize = CGSizeZero
    private var dynamicAnimator: UIDynamicAnimator! // the dynamic animator is what provides the spring effect when scrolling
    private var latestDelta: CGFloat = 0.0
    
    override init() {
        super.init()
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    func resetLayout() {
        points.removeAll()
        dynamicAnimator.removeAllBehaviors()
    }

    override public func prepareLayout() {
        guard let collectionView = self.collectionView, itemCount = self.collectionView?.numberOfItemsInSection(0) where itemCount > 0 && reset
            else { return }
        
        reset = false
        resetLayout()
        
        let insets = collectionView.contentInset
        let halfWidth = itemSize.width*0.5
        let halfHeight = itemSize.height*0.5
        let p0 = scrollDirection == .Horizontal ? CGPoint.roundedPoint(x: insets.left + halfWidth, y: collectionView.bounds.midY) : CGPoint.roundedPoint(x: collectionView.bounds.midX, y: insets.top + halfHeight)
        
        let side: CGFloat = (scrollDirection == .Horizontal ? itemSize.width : itemSize.height) + itemSpacing

        var firstPair = PointPair()
        firstPair.scrollDirection = scrollDirection
        firstPair.first = DirectedPoint(point: p0, scrollDirection: scrollDirection)
        
        if itemCount > 1 {
            var x1: CGFloat!
            var y1: CGFloat!
            
            if scrollDirection == .Horizontal {
                x1 = p0.x + startingOffset
                y1 = sqrt((side*side) - ((x1 - p0.x)*(x1 - p0.x))) + p0.y
            }
            else {
                y1 = p0.y + startingOffset
                x1 = p0.x - sqrt((side*side) - ((y1 - p0.y)*(y1 - p0.y)))
            }
            
            firstPair.second = DirectedPoint(point: CGPoint.roundedPoint(x: x1, y: y1), scrollDirection: scrollDirection)
        }
        
        let maxVal = generatePoints(firstPair, itemCount: itemCount, bounds: collectionView.bounds, halfWidth: halfWidth, halfHeight: halfHeight)
        
        if scrollDirection == .Horizontal {
            contentSize = CGSize(width: maxVal + halfWidth + 20, height: collectionView.bounds.height - (insets.top + insets.bottom))
        }
        else {
            contentSize = CGSize(width: collectionView.bounds.width - (insets.left + insets.right), height: maxVal + halfWidth + 20)
        }
        
        var itemIndex = 0
//        var pointOut = "\n"
        
        let touchLocation = collectionView.panGestureRecognizer.locationInView(collectionView)
        
        for directedPoint in points {
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: itemIndex++, inSection: 0))
            attributes.size = itemSize
            attributes.center = directedPoint.point
            var center = directedPoint.point
            
//            pointOut += "\(directedPoint.point.x),\(directedPoint.point.y)\n"
            
            let springBehaviour = UIAttachmentBehavior(item: attributes, attachedToAnchor: directedPoint.point)
            springBehaviour.length = 0.0
            springBehaviour.damping = 0.8
            springBehaviour.frequency = 1.0
            
            if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
                let yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y)
                let xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                
                if latestDelta < 0 {
                    if scrollDirection == .Vertical {
                        center.y += max(latestDelta, latestDelta*scrollResistance)
                    }
                    else {
                        center.x += max(latestDelta, latestDelta*scrollResistance)
                    }
                }
                else {
                    if scrollDirection == .Vertical {
                        center.y += min(latestDelta, latestDelta*scrollResistance)
                    }
                    else {
                        center.x += min(latestDelta, latestDelta*scrollResistance)
                    }
                }
                
                attributes.center = center;
            }
            
            dynamicAnimator.addBehavior(springBehaviour)
        }
//        print(pointOut + "\n")
    }

    private func generatePoints(firstPair: PointPair, itemCount: Int, bounds: CGRect, halfWidth: CGFloat, halfHeight: CGFloat) -> CGFloat {
//        let start = NSDate().timeIntervalSince1970
        
        var pairs = [PointPair]()
        pairs.append(firstPair)
        
        var pairSet = Set<PointPair>()
        pairSet.insert(firstPair)
        
        var visited = Set<PointPair>()
        
        points.insertInOrder(firstPair.first)
        points.insertInOrder(firstPair.second)
        
        let containingRect = scrollDirection == .Horizontal ? CGRect(x: 0, y: 0, width: CGFloat.max, height: bounds.height) : CGRect(x: 0, y: 0, width: bounds.width, height: CGFloat.max)
        
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
        
//        let end = NSDate().timeIntervalSince1970
//        print("generating points took \(end - start) seconds")
        
        return scrollDirection == .Horizontal ? maxX : maxY
    }
    
    func addNewPairs(containingRect: CGRect, pair: PointPair, point: DirectedPoint, halfWidth: CGFloat, halfHeight: CGFloat, visited: Set<PointPair>) -> (pairs: [PointPair], contained: Bool) {
        if CGRectContainsRect(containingRect, CGRectMake(point.point.x - halfWidth, point.point.y - halfHeight, itemSize.width, itemSize.width)) {
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
    
    override public func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = self.dynamicAnimator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
        return attributes
    }

    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else { return false }
        let delta = scrollDirection == .Vertical ?
            newBounds.origin.y - collectionView.bounds.origin.y :
            newBounds.origin.x - collectionView.bounds.origin.x
        
        latestDelta = delta
        
        let touchLocation = collectionView.panGestureRecognizer.locationInView(collectionView)
        
        if let behaviors = dynamicAnimator.behaviors as? [UIAttachmentBehavior] {
            for springBehaviour in behaviors {
                let yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y)
                let xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                
                if let item = springBehaviour.items.first as? UICollectionViewLayoutAttributes {
                    var center = item.center
                    if delta < 0 {
                        if scrollDirection == .Vertical {
                            center.y += max(delta, delta*scrollResistance)
                        }
                        else {
                            center.x += max(delta, delta*scrollResistance)
                        }
                    }
                    else {
                        if scrollDirection == .Vertical {
                            center.y += min(delta, delta*scrollResistance)
                        }
                        else {
                            center.x += min(delta, delta*scrollResistance)
                        }
                    }
                    item.center = center
                    
                    dynamicAnimator.updateItemUsingCurrentState(item)
                }
            }
        }
        
        return false
    }
}
