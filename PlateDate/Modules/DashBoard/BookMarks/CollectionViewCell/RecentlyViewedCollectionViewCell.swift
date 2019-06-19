//
//  RecentlyViewedCollectionViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 08/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class RecentlyViewedCollectionViewCell: UICollectionViewCell {

    //Mark : - @IBOutlets
    @IBOutlet var recentlyViewRecipeImageView: UIImageView!
    @IBOutlet var recentlyViewRecipeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
         recentlyViewRecipeImageView.clipsToBounds = true
        // Initialization code
    }
}
