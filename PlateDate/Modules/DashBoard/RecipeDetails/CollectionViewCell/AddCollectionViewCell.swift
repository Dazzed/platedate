//
//  AddCollectionViewCell.swift
//  PlateDate
//
//  Created by WebCrafters on 13/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class AddCollectionViewCell: UICollectionViewCell {

    // Mark: - @IBOutlets
    @IBOutlet var addCollectionImageView: UIImageView!
    @IBOutlet var addCollectionName: UILabel!
    @IBOutlet weak var addIconImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        addCollectionImageView.clipsToBounds = true
        // Initialization code
    }
}
