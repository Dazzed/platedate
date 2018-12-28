//
//  DietaryRestrictions.swift
//  PlateDate
//
//  Created by WebCrafters on 11/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit


class DietaryRestrictionsView: UIView {

    // MARK: - @IBOutlets
    @IBOutlet var dietaryTableView: UITableView!

    // MARK: - Lifecycle
    override init(frame: CGRect) {
    super.init(frame: frame)
      //  setup()
    }

    required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
        //setup()
       // reuseIdentifier()
        
    }

    //MARK: - Private Methods
    private func setup() {
        //reuseIdentifier()
    }
}
