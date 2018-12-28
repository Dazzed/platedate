//
//  UsernameView.swift
//  PlateDate
//
//  Created by WebCrafters on 11/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class UserNameView: UIView {

    @IBOutlet var userNameTextField: UITextField!

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    //MARK: - Private Methods
    private func setup() {

    }
}
