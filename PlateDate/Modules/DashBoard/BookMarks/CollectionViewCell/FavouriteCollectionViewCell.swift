//
//  FavouriteCollectionViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 15/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {

    // Mark: - @IBOutlets
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var favouriteDeleteButton: UIButton!
    @IBOutlet weak var favouriteNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
