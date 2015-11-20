//
//  PhotoView.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import UIKit

enum EquilateralPhotoType {
    case Hexagon
    case Circle
}

class EquilateralPhotoView: UIView {
    
    var strokeColor: UIColor = UIColor(fromHexValue: 0xFFB8E986) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var strokeWidth: CGFloat = 5 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet {
            self.profilePicView.frame = self.bounds
        }
    }
    
    var hexagonProfilePicType = HexagonProfilePicType.Circle {
        didSet {
            self.profilePicView.frame = self.bounds
        }
    }
    
    let profilePicView = UIImageView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SphereColors.clear
        self.profilePicView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.profilePicView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var hexagonPath: UIBezierPath!
        
        if self.hexagonProfilePicType == .Hexagon {
            hexagonPath = UIBezierPath()
            hexagonPath.moveToPoint(CGPointMake(rect.minX + 0.5 * rect.width, rect.minY + 0.01 * rect.height + self.strokeWidth))
            hexagonPath.addLineToPoint(CGPointMake(rect.minX + 0.98851 * rect.width - self.strokeWidth, rect.minY + 0.255 * rect.height + self.strokeWidth*0.25))
            hexagonPath.addLineToPoint(CGPointMake(rect.minX + 0.98851 * rect.width - self.strokeWidth, rect.minY + 0.745 * rect.height - self.strokeWidth*0.25))
            hexagonPath.addLineToPoint(CGPointMake(rect.minX + 0.5 * rect.width, rect.minY + 0.99 * rect.height - self.strokeWidth))
            hexagonPath.addLineToPoint(CGPointMake(rect.minX + 0.01149 * rect.width, rect.minY + 0.745 * rect.height - self.strokeWidth*0.25))
            hexagonPath.addLineToPoint(CGPointMake(rect.minX + 0.01149 * rect.width, rect.minY + 0.255 * rect.height + self.strokeWidth*0.25))
            hexagonPath.addLineToPoint(CGPointMake(rect.minX + 0.5 * rect.width, rect.minY + 0.01 * rect.height + self.strokeWidth))
            hexagonPath.closePath()
        }
        else {
            hexagonPath = UIBezierPath(arcCenter: CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height), radius: 0.5 * min(self.bounds.size.width, self.bounds.size.height) - self.strokeWidth, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: false)
        }
        
        hexagonPath.lineWidth = self.strokeWidth
        self.strokeColor.setStroke()
        hexagonPath.stroke()
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = hexagonPath.CGPath;
        self.profilePicView.layer.mask = maskLayer
    }
    
}

