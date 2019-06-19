//
//  FollowingRecipiesTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 04/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class FollowingRecipiesTableViewCell: UITableViewCell {

    @IBOutlet var followingRecipeImageView: UIImageView!
    @IBOutlet var bottomView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        followingRecipeImageView.clipsToBounds = true
    }
}
