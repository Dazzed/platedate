//
//  CommunityViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 26/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
