//
//  AddStepTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 09/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class AddStepTableViewCell: UITableViewCell {

    // Mark: - @IBOutlets
    @IBOutlet var addStepLabel: UILabel!
    @IBOutlet var stepRemoveButton: UIButton!
    @IBOutlet var stepCountLabel: CircleLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
