//
//  CommentsTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 01/04/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: ProfileImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var commentsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
     mainView.clipsToBounds = true
     commentImageView.clipsToBounds = false
        //commentImageView.clipsToBounds = true
        // Initialization code        mainView.addShadow(to: [.left, .right, .bottom], radius: 3.0, view: mainView)
    }
}
