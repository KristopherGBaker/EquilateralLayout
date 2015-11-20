//
//  PhotoView.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import UIKit

class EquilateralPhotoView: UIView {
    
    var strokeColor: UIColor = UIColor(red: 0xB8/255.0, green: 0xE9/255.0, blue: 0x68/255.0, alpha: 1.0) {
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
            self.imageView.frame = self.bounds
        }
    }
    
    let imageView = UIImageView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(arcCenter: CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height), radius: 0.5 * min(self.bounds.size.width, self.bounds.size.height) - self.strokeWidth, startAngle: 0, endAngle: 2 * CGFloat(M_PI), clockwise: false)
        
        path.lineWidth = self.strokeWidth
        self.strokeColor.setStroke()
        path.stroke()
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = path.CGPath;
        self.imageView.layer.mask = maskLayer
    }
    
}

