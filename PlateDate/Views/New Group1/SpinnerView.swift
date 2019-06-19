//
//  SpinnerView.swift
//  PlateDate
//
//  Created by WebCrafters on 24/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class SpinnerView: UIView {

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

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

