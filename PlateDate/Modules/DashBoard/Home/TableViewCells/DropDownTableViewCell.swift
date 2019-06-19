//
//  DropDownTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 17/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
