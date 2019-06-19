//
//  ProfileRecipeTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 30/04/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class ProfileRecipeTableViewCell: UITableViewCell {

    @IBOutlet var profileRecipeImageView: UIImageView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var recipeTitleLabel: UILabel!
    @IBOutlet var recipeBookMarkButton: UIButton!
    @IBOutlet var recipeUserNameLabel: UILabel!
    @IBOutlet var recipeUserImageView: ProfileImageView!
    @IBOutlet var recipeDescriptionLabel: UILabel!
    @IBOutlet var recipeTimeLabel: UILabel!
    @IBOutlet weak var mainView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileRecipeImageView.clipsToBounds = true
    }
}
