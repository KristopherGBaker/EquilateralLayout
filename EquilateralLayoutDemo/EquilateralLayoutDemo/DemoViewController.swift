//
//  HorizontalDemoViewController.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var layout: EquilateralLayout!
    var items = [EquilateralPhotoItem]()
    var numberOfItems: Int!
    var strokeColor: UIColor!
    var scrollDirection: UICollectionViewScrollDirection!
    
    init(numberOfItems: Int, strokeColor: UIColor, scrollDirection: UICollectionViewScrollDirection) {
        super.init(nibName: nil, bundle: nil)
        self.numberOfItems = numberOfItems
        self.strokeColor = strokeColor
        self.scrollDirection = scrollDirection
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        generateRandomItems()
        setupLayout()
        setupCollectionView()
    }
    
    func setupLayout() {
        layout = EquilateralLayout()
        layout.scrollDirection = scrollDirection
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.startingOffset = 80.0
        layout.itemSpacing = 8.0
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 44), collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(EquilateralPhotoCell.self, forCellWithReuseIdentifier: EquilateralPhotoCell.ReuseIdentifier)
        self.view.addSubview(self.collectionView)
    }
    
    func generateRandomItems() {
        for index in 0..<numberOfItems {
            let photoURL: NSURL! = NSURL(string: "http://lorempixel.com/200/200/?_=\(index)")
            let item = (photoURL, strokeColor)
            items.append(item)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(EquilateralPhotoCell.ReuseIdentifier, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let photoCell = cell as? EquilateralPhotoCell {
            photoCell.configure(self.items[indexPath.item])
        }
    }
}
