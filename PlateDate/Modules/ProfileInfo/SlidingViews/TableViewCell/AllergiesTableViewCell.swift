//
//  AllergiesTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 12/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class AllergiesTableViewCell: UITableViewCell {
    
    @IBOutlet var allergiesLabel: UILabel!
    @IBOutlet var selectImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
