//
//  MeasurementTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 09/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class MeasurementTableViewCell: UITableViewCell {

    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var measurementLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
