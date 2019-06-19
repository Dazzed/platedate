//
//  NutritionFactsTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 22/03/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class NutritionFactsTableViewCell: UITableViewCell {

    @IBOutlet weak var nutritionNameLabel: UILabel!
    @IBOutlet weak var nutritionAmountLabel: UILabel!
    @IBOutlet weak var nutritionPercentage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
