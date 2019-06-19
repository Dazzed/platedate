//
//  TrendingRecipiesTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 04/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Parse

class TrendingRecipiesTableViewCell: UITableViewCell {

    @IBOutlet var trendingRecipeImageView: UIImageView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var recipeTitleLabel: UILabel!
    @IBOutlet var recipeBookMarkButton: UIButton!
    @IBOutlet var recipeUserNameLabel: UILabel!
    @IBOutlet var recipeUserImageView: ProfileImageView!
    @IBOutlet var recipeDescriptionLabel: UILabel!
    @IBOutlet var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipeUserButton: UIButton!


    @IBOutlet weak var mainView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        trendingRecipeImageView.clipsToBounds = true

        
    }
}
