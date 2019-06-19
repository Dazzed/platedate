
//
//  EmailLoginViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import SendGrid_Swift

class EmailLoginViewController: UIViewController, UITextFieldDelegate {

    // Mark: - @IBOutlets 
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var alertLabelBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Mark: - Keyboard Notification
        keyBoardNotification()
        LoadSpinnerView()
    }

     func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        spinnerView.isHidden = true
    }

    // Mark: - Keyboard Will Show
    func keyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(EmailLoginViewController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        emailLogin()
    }

    // Mark: - Keyboard Show Notification
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                   // self.view.frame.origin.y -= keyboardSize.height
                   KeyBoard.height = keyboardSize.height
                   switch UIScreen.main.nativeBounds.height {
                    case 1334:
                        alertLabelBottomConstraint.constant =  KeyBoard.height + 10
                    case 1920, 2208:
                        alertLabelBottomConstraint.constant =  KeyBoard.height + 10
                    case 2436:
                        alertLabelBottomConstraint.constant =  KeyBoard.height + 30
                    case 2688:
                        alertLabelBottomConstraint.constant =  KeyBoard.height + 35
                    case 1792:
                        alertLabelBottomConstraint.constant =  KeyBoard.height + 30
                    case 2688:
                        alertLabelBottomConstraint.constant =  KeyBoard.height + 30
                    default:
                        alertLabelBottomConstraint.constant =  KeyBoard.height + 20
                }
            }
        }
    }
    
    // Mark: - Email Login
    func emailLogin() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) else {return}
        let fieldUpdate = !email.isEmpty
         if fieldUpdate {
            if email.isValidEmail() {
                if Connectivity.isConnectedToInternet {
                    PassValue.email = email
                    spinnerView.isHidden = false
                    sendMail()
                } else {
                    alert(title: "Erorr!", message: "Please Check Your Internet Connection", cancel: "Dismiss")
                }
            } else {
                 alert(title: "Erorr!", message: "Please Enter Valid Email Address", cancel: "Dismiss")
            }
         } else {
            alert(title: "Erorr!", message: "Please Enter Your Email-id", cancel: "Dismiss")
         }
    }

     // Mark: - Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    //Mark: - TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          if textField == emailTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
        return true
    }

    //Mark: - Send Email Using Send Grid
    func sendMail() {
        PassValue.otp = generateRandomDigits(6) 
        let sendGrid = SendGrid(withAPIKey: API.sendGridAPIKey)
        let content = SGContent(type: .plain, value: PassValue.otp)
        let from = SGAddress(email: API.sendGridFromEmail)
        let personalization = SGPersonalization(to: [ SGAddress(email: PassValue.email) ])
        let subject = "Platedate Email successfully received"
        let email = SendGridEmail(personalizations: [personalization], from: from, subject: subject, content: [content])
        sendGrid.send(email: email) { (response, error) in
            if let error = error {
                self.spinnerView.isHidden = true
                print("Error sending email: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    print(PassValue.email)
                    self.spinnerView.isHidden = true
                    self.navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.checkEmailStoryBoardId)
                }
            }
        }
    }
}
