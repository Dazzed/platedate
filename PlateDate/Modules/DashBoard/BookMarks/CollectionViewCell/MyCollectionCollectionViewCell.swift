//
//  MyCollectionCollectionViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 08/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class MyCollectionCollectionViewCell: UICollectionViewCell {

    // Mark: - @IBOutlets
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet weak var addIconImageView: UIImageView!
    @IBOutlet weak var backGroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImageView.clipsToBounds = true
        // Initialization code
    }
}
