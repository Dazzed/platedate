//
//  ReplyTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 02/04/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var replyUserImageView: UIImageView!
    @IBOutlet weak var replyUsernameLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var replyTimeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
