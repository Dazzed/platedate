//
//  CheckEmailViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 07/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Parse
import SendGrid_Swift

class CheckEmailViewController: UIViewController {

    // Mark: - @IBOutlets
    @IBOutlet weak var otpTextField: PinCodeTextField!
    @IBOutlet var emailDisplayLabel: UILabel!

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(PassValue.otp)
        // Do any additional setup after loading the view.
        LoadSpinnerView()
    }

     func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(PassValue.email)
        // MARK: - Change Border Color TextField Delegate
        otpTextField.delegate = self
        otpTextField.underlines[0].backgroundColor = UIColor._lightningYellow
        otpTextField.becomeFirstResponder()
        otpTextField.keyboardType = .phonePad
        otpTextField.font = UIFont(name:"SourceSansPro-Bold",size:20)!
        let emailReplace = emailDisplayLabel.text!
         print(PassValue.email)
         print(emailReplace)
        emailDisplayLabel.text = emailReplace.replacingOccurrences(of: "name@example.com", with: PassValue.email)
        spinnerView.isHidden = true
    }

     // Mark: - Resent OTP Action
    @IBAction func resendOTPAction(_ sender: Any) {
        spinnerView.isHidden = false
        PassValue.otp = generateRandomDigits(6)
        let sendGrid = SendGrid(withAPIKey: API.sendGridAPIKey)
        let content = SGContent(type: .plain, value: PassValue.otp)
        let from = SGAddress(email: API.sendGridFromEmail)
        let personalization = SGPersonalization(to: [ SGAddress(email: PassValue.email) ])
        let subject = "Platedate Email successfully received"
        let email = SendGridEmail(personalizations: [personalization], from: from, subject: subject, content: [content])
        sendGrid.send(email: email) { (response, error) in
            if let error = error {
                print("Error sending email: \(error.localizedDescription)")
            } else {
                print("sent successful")
            }
            self.spinnerView.isHidden = true
        }
    }

    // Mark: - Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
}

extension CheckEmailViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {

    }

    // MARK: - TextField Change UnderLine color
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        if value.count == 0 {
            otpTextField.underlines[0].backgroundColor = UIColor._lightningYellow
        } else if value.count == 1 {
            otpTextField.underlines[0].backgroundColor = UIColor.clear
            otpTextField.underlines[1].backgroundColor = UIColor._lightningYellow
        } else if value.count == 2 {
            otpTextField.underlines[1].backgroundColor = UIColor.clear
            otpTextField.underlines[2].backgroundColor = UIColor._lightningYellow
        } else if value.count == 3 {
            otpTextField.underlines[2].backgroundColor = UIColor.clear
            otpTextField.underlines[3].backgroundColor = UIColor._lightningYellow
        } else if value.count == 4 {
            otpTextField.underlines[3].backgroundColor = UIColor.clear
            otpTextField.underlines[4].backgroundColor = UIColor._lightningYellow
        } else if value.count == 5 {
            otpTextField.underlines[4].backgroundColor = UIColor.clear
            otpTextField.underlines[5].backgroundColor = UIColor._lightningYellow
        } else if value.count == 6 {
            otpTextField.underlines[5].backgroundColor = UIColor.clear
            OTPVerify()
        }
    }

    // MARK: - Email OTP
    func OTPVerify() {
        guard let otp = otpTextField.text?.trimmingCharacters(in: .whitespaces) else {return}
        if Connectivity.isConnectedToInternet {
            if PassValue.otp == otp {
                spinnerView.isHidden = false
                let user = PFUser()
                user.username = PassValue.email
                user.password = PassValue.email
                //user.email = PassValue.email
                user.signUpInBackground(block: { (succeeded, error) in
                    if let error = error  {
                        print("errorworking\(error.localizedDescription)")
                        if error.localizedDescription == "Account already exists for this username." {
                           self.oldUser()
                        }
                    } else {
                        User.firstLogin = true
                        self.login()
                    }
                    self.spinnerView.isHidden = true
                })
            } else {
                self.alert(title: "Error", message: "Your OTP number is wrong", cancel: "Dismiss")
            }
        } else {
            self.alert(title: "Error", message: "Please Check Your Internet Connection", cancel: "Dismiss")
        }
    }

    // MARK: - Old User
    func oldUser() {
        PFUser.logInWithUsername(inBackground: PassValue.email, password:PassValue.email) { (user, error) in
            if user != nil {
                User.firstLogin = false
                self.login()

            } else {
                print(error?.localizedDescription ?? "")
            }
            self.spinnerView.isHidden = true
        }
    }

    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}
