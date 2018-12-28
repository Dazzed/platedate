//
//  DieataryTableViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 11/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class DieataryTableViewCell: UITableViewCell {

    @IBOutlet var dieataryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
