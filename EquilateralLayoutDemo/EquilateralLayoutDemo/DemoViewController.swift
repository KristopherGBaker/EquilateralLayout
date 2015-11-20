//
//  HorizontalDemoViewController.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import UIKit

class HorizontalDemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var layout: EquilateralLayout!
    var items = [EquilateralPhotoItem]()
    var numberOfItems = 200
    var strokeColor = UIColor.redColor()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem.image = UIImage(named: "horizontal")
        self.tabBarItem.title = "Horizontal"
        
        generateRandomItems()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    func setupCollectionView() {
//        self.collectionView = UICollectionView(frame: self.view.bounds), collectionViewLayout:layout)
//        self.collectionView.backgroundColor = SphereColors.clear
//        self.collectionView.delegate = self
//        self.collectionView
//            .dataSource = self
//        
//        if self.useEquilateralLayout {
//            self.feedView.registerClass(HexagonProfilePicCell.self, forCellWithReuseIdentifier: HexagonProfilePicCell.ReuseIdentifier)
//        }
//        else {
//            self.feedView.registerClass(NetworkUserCell.self, forCellWithReuseIdentifier: NetworkUserCell.ReuseIdentifier)
//        }
//        self.view.addSubview(self.feedView)
    }
    
    func generateRandomItems() {
        for index in 0..<numberOfItems {
            let item = (NSURL(string: "http://lorempixel.com/200/200/?_=\(index)")!, strokeColor)
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
