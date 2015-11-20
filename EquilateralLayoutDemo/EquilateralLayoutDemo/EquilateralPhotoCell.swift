//
//  PhotoCell.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import UIKit
import SDWebImage

typealias EquilateralPhotoItem = (photoURL: NSURL!, strokeColor: UIColor!)

class EquilateralPhotoCell: UICollectionViewCell {
    
    static let ReuseIdentifier = "EquilateralPhotoCell"
    
    let equilateralPhotoView = EquilateralPhotoView(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.equilateralPhotoView.frame = CGRectMake(0, 0, frame.width, frame.height)
        self.contentView.addSubview(self.equilateralPhotoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: EquilateralPhotoItem) {
        self.equilateralPhotoView.strokeColor = item.strokeColor
        self.equilateralPhotoView.imageView.sd_setImageWithURL(item.photoURL)
    }
}