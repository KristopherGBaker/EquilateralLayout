//
//  HorizontalDemoViewController.swift
//  EquilateralLayoutDemo
//
//  Created by Kristopher Baker on 11/19/15.
//  Copyright © 2015 Kris Baker. All rights reserved.
//

import EquilateralLayout
import UIKit

class DemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var layout: EquilateralLayout!
    var items = [EquilateralPhotoItem]()
    var numberOfItems: Int
    var strokeColor: UIColor
    var scrollDirection: UICollectionViewScrollDirection
    
    init(numberOfItems: Int, strokeColor: UIColor, scrollDirection: UICollectionViewScrollDirection) {
        self.strokeColor = strokeColor
        self.numberOfItems = numberOfItems
        self.scrollDirection = scrollDirection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
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
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 44), collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EquilateralPhotoCell.self, forCellWithReuseIdentifier: EquilateralPhotoCell.ReuseIdentifier)
        self.view.addSubview(self.collectionView)
    }
    
    func generateRandomItems() {
        for index in 0..<numberOfItems {
            let photoURL: URL = URL(string: "http://lorempixel.com/200/200/?_=\(index)")!
            let item = (photoURL: photoURL, strokeColor: strokeColor)
            items.append(item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: EquilateralPhotoCell.ReuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photoCell = cell as? EquilateralPhotoCell {
            photoCell.configure(self.items[indexPath.item])
        }
    }
}
