//
//  ProfileImageView.swift
//  PlateDate
//
//  Created by WebCrafters on 04/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class ProfileImageView:UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageView()
    }

    func setupImageView() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}
