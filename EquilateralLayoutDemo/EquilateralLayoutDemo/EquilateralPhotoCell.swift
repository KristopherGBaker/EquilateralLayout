//
//  PhotoCell.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import PINRemoteImage
import UIKit

class EquilateralPhotoCell: UICollectionViewCell {
    
    static let ReuseIdentifier = "EquilateralPhotoCell"
    
    override var frame: CGRect {
        didSet {
            layer.cornerRadius = bounds.height * 0.5
        }
    }
    
    private let imageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        
        contentView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        layer.borderColor = UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: 1.0).cgColor
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    }
    
    func configure(url: URL) {
        imageView.pin_setImage(from: url)
    }
}
