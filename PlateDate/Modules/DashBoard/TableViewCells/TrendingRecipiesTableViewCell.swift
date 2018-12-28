//
//  TrendingRecipiesTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 04/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class TrendingRecipiesTableViewCell: UITableViewCell {

    @IBOutlet var trendingRecipeImageView: UIImageView!
    @IBOutlet var bottomView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        trendingRecipeImageView.clipsToBounds = true
    }
}






