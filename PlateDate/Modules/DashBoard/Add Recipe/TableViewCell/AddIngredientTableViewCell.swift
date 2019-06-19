//
//  AddIngredientTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 09/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell {
    // Mark: - @IBOutlets
    @IBOutlet var addIngredientNameLabel: UILabel!
    @IBOutlet var removeIngredientButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
