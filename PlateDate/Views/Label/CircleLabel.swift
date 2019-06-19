//
//  CircleLabel.swift
//  PlateDate
//
//  Created by WebCrafters on 06/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class CircleLabel:UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUpLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUpLabel()
    }

    func setupUpLabel() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}
