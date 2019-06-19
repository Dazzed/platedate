//
//  ProfileDietaryTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 09/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class ProfileDietaryTableViewCell: UITableViewCell {

    @IBOutlet weak var dietaryLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
