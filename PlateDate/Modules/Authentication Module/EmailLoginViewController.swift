
//
//  EmailLoginViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class EmailLoginViewController: UIViewController {

    // Mark: - @IBOutlets 
    @IBOutlet var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        emailLogin()
    }

    // Mark: - Email Login
    func emailLogin() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) else {return}
        let fieldUpdate = !email.isEmpty
        PassValue.email = email
         if fieldUpdate {
            if email.isValidEmail() {
                APIClient.shared.emailLogin(email: email, completion: { (success, error) in
                    if success {
                        self.navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.checkEmailStoryBoardId)
                        print(User.message)
                    } else {
                        print(error?.localizedDescription ?? "")
                    }
                })
            } else {
                 alert(title: "Erorr!", message: "Please Enter Valid Email Addres", cancel: "Dismiss")
            }
         } else {
            alert(title: "Erorr!", message: "Please Enter Your Email-id", cancel: "Dismiss")
         }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
