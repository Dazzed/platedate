//
//  CheckEmailViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 07/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class CheckEmailViewController: UIViewController {

    @IBOutlet var emailSentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let emailReplace = emailSentLabel.text!
        emailSentLabel.text = emailReplace.replacingOccurrences(of: "name@example.com", with: PassValue.email)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
