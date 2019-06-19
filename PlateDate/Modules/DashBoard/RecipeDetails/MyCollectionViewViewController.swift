//
//  MyCollectionViewViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 13/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class MyCollectionViewController: UIViewController {

    @IBOutlet var addCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionReuseIdentifier()
    }

    func myCollectionReuseIdentifier() {
        let nibName1 = UINib(nibName: "AddCollectionViewCell", bundle:nil)
        addCollectionView.register(nibName1, forCellWithReuseIdentifier: "AddCollectionCell")
        addCollectionView.delegate = self
        addCollectionView.dataSource = self
        addCollectionView.backgroundColor = .clear
        addCollectionView.reloadData()
    }
}

extension BookMarkViewController: UICollectionViewDataSource,UICollectionViewDelegate {

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        if collectionView == recentlyViewedCollectionView {
              let cell = addCollectionView.dequeueReusableCell(withReuseIdentifier: "AddCollectionCell", for: indexPath as IndexPath) as! AddCollectionViewCell
              cell.backgroundColor = .clear
              return cell
        }
    }
}
