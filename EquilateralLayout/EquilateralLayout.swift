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

    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            resetLayout()
        }
    }
    
    public var itemSize: CGSize = CGSize(width: 90, height: 90)
    public var startingOffset: CGFloat = 80.0
    public var itemSpacing: CGFloat = 8.0
    public var reset: Bool = true
    
    fileprivate var points = [DirectedPoint]()
    fileprivate var contentSize: CGSize = .zero
    fileprivate var dynamicAnimator: UIDynamicAnimator! // the dynamic animator is what provides the spring effect when scrolling
    fileprivate var latestDelta: CGFloat = 0.0
    
    public override init() {
        super.init()
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    public func resetLayout() {
        points.removeAll()
        dynamicAnimator.removeAllBehaviors()
    }

    override public func prepare() {
        guard let collectionView = self.collectionView, let itemCount = self.collectionView?.numberOfItems(inSection: 0), itemCount > 0 && reset
            else { return }
        
        reset = false
        resetLayout()
        
        let insets = collectionView.contentInset
        let halfWidth = itemSize.width*0.5
        let halfHeight = itemSize.height*0.5
        let p0 = scrollDirection == .horizontal ? CGPoint.roundedPoint(x: insets.left + halfWidth, y: collectionView.bounds.midY) : CGPoint.roundedPoint(x: collectionView.bounds.midX, y: insets.top + halfHeight)
        
        let side: CGFloat = (scrollDirection == .horizontal ? itemSize.width : itemSize.height) + itemSpacing

        var firstPair = PointPair()
        firstPair.scrollDirection = scrollDirection
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
        
        let maxVal = generatePoints(firstPair, itemCount: itemCount, bounds: collectionView.bounds, halfWidth: halfWidth, halfHeight: halfHeight)
        
        if scrollDirection == .horizontal {
            contentSize = CGSize(width: maxVal + halfWidth + 20, height: collectionView.bounds.height - (insets.top + insets.bottom))
        }
        else {
            contentSize = CGSize(width: collectionView.bounds.width - (insets.left + insets.right), height: maxVal + halfWidth + 20)
        }
        
        var itemIndex = 0
//        var pointOut = "\n"
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        for directedPoint in points {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: itemIndex, section: 0))
            itemIndex = itemIndex + 1
            attributes.size = itemSize
            attributes.center = directedPoint.point
            var center = directedPoint.point
            
//            pointOut += "\(directedPoint.point.x),\(directedPoint.point.y)\n"
            
            let springBehaviour = UIAttachmentBehavior(item: attributes, attachedToAnchor: directedPoint.point)
            springBehaviour.length = 0.0
            springBehaviour.damping = 0.8
            springBehaviour.frequency = 1.0
            
            if (!CGPoint.zero.equalTo(touchLocation)) {
                let yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y)
                let xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                
                if latestDelta < 0 {
                    if scrollDirection == .vertical {
                        center.y += max(latestDelta, latestDelta*scrollResistance)
                    }
                    else {
                        center.x += max(latestDelta, latestDelta*scrollResistance)
                    }
                }
                else {
                    if scrollDirection == .vertical {
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

    fileprivate func generatePoints(_ firstPair: PointPair, itemCount: Int, bounds: CGRect, halfWidth: CGFloat, halfHeight: CGFloat) -> CGFloat {
//        let start = NSDate().timeIntervalSince1970
        
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
        
//        let end = NSDate().timeIntervalSince1970
//        print("generating points took \(end - start) seconds")
        
        return scrollDirection == .horizontal ? maxX : maxY
    }
    
    func addNewPairs(_ containingRect: CGRect, pair: PointPair, point: DirectedPoint, halfWidth: CGFloat, halfHeight: CGFloat, visited: Set<PointPair>) -> (pairs: [PointPair], contained: Bool) {
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
    
    override public var collectionViewContentSize : CGSize {
        return contentSize
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator.layoutAttributesForCell(at: indexPath)
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = self.dynamicAnimator.items(in: rect) as? [UICollectionViewLayoutAttributes]
        return attributes
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else { return false }
        let delta = scrollDirection == .vertical ?
            newBounds.origin.y - collectionView.bounds.origin.y :
            newBounds.origin.x - collectionView.bounds.origin.x
        
        latestDelta = delta
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        if let behaviors = dynamicAnimator.behaviors as? [UIAttachmentBehavior] {
            for springBehaviour in behaviors {
                let yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y)
                let xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                
                if let item = springBehaviour.items.first as? UICollectionViewLayoutAttributes {
                    var center = item.center
                    if delta < 0 {
                        if scrollDirection == .vertical {
                            center.y += max(delta, delta*scrollResistance)
                        }
                        else {
                            center.x += max(delta, delta*scrollResistance)
                        }
                    }
                    else {
                        if scrollDirection == .vertical {
                            center.y += min(delta, delta*scrollResistance)
                        }
                        else {
                            center.x += min(delta, delta*scrollResistance)
                        }
                    }
                    item.center = center
                    
                    dynamicAnimator.updateItem(usingCurrentState: item)
                }
            }
        }
        
        return false
    }
}
