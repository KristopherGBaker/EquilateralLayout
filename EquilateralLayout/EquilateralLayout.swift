//
//  EquilateralLayout.swift
//  Sphere
//
//  Created by Kristopher Baker on 10/29/15.
//  Copyright © 2017 EmpyrealNight, LLC. All rights reserved.
//

public class EquilateralLayout: UICollectionViewLayout {

    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            points.scrollDirection = scrollDirection
            resetLayout()
        }
    }
    
    public var itemSize: CGSize = CGSize(width: 90, height: 90) {
        didSet {
            points.itemSize = itemSize
        }
    }
    
    public var startingOffset: CGFloat = 80.0 {
        didSet {
            points.startingOffset = startingOffset
        }
    }
    
    public var itemSpacing: CGFloat = 8.0 {
        didSet {
            points.itemSpacing = itemSpacing
        }
    }
    
    public var reset: Bool = true
    
    var points = EquilateralPoints()
    
//    private var points = [DirectedPoint]()
    private var contentSize: CGSize = .zero
    private var dynamicAnimator: UIDynamicAnimator! // the dynamic animator is what provides the spring effect when scrolling
    private var latestDelta: CGFloat = 0.0
    
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
        points.points.removeAll()
        dynamicAnimator.removeAllBehaviors()
    }

    override public func prepare() {
        guard let collectionView = self.collectionView, let itemCount = self.collectionView?.numberOfItems(inSection: 0), itemCount > 0 && reset
            else { return }
        
        reset = false
        resetLayout()
        
        let insets = collectionView.contentInset
        let halfWidth = itemSize.width*0.5
        
        let maxVal = points.generate(insets: insets, bounds: collectionView.bounds, itemCount: itemCount)
        
        if scrollDirection == .horizontal {
            contentSize = CGSize(width: maxVal + halfWidth + 20, height: collectionView.bounds.height - (insets.top + insets.bottom))
        }
        else {
            contentSize = CGSize(width: collectionView.bounds.width - (insets.left + insets.right), height: maxVal + halfWidth + 20)
        }
        
        var itemIndex = 0
        
        let touchLocation = collectionView.panGestureRecognizer.location(in: collectionView)
        
        for directedPoint in points.points {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: itemIndex, section: 0))
            itemIndex = itemIndex + 1
            attributes.size = itemSize
            attributes.center = directedPoint.point
            var center = directedPoint.point
            
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
