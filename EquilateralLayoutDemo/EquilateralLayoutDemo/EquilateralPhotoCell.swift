//
//  PhotoCell.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import UIKit
import PINRemoteImage

typealias EquilateralPhotoItem = (photoURL: URL, strokeColor: UIColor)

class EquilateralPhotoCell: UICollectionViewCell {
    
    static let ReuseIdentifier = "EquilateralPhotoCell"
    
    let equilateralPhotoView = EquilateralPhotoView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.equilateralPhotoView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.contentView.addSubview(self.equilateralPhotoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: EquilateralPhotoItem) {
        self.equilateralPhotoView.strokeColor = item.strokeColor
        self.equilateralPhotoView.imageView.pin_setImage(from: item.photoURL)
    }
}
