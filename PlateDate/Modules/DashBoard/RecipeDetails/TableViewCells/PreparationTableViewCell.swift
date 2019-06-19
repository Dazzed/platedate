//
//  PreparationTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 02/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class PreparationTableViewCell: UITableViewCell {

    @IBOutlet var countLabel: UILabel!
    @IBOutlet var preparationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
