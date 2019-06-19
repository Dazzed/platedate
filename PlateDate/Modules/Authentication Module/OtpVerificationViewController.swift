//
//  MobileVerificationViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 06/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Parse
import Alamofire

class OtpVerificationViewController: UIViewController, UITextFieldDelegate {

    // Mark: - @IBOutlets
    @IBOutlet weak var otpTextField: PinCodeTextField!
    @IBOutlet var numberDisplayLabel: UILabel!

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadSpinnerView()
    }

    func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(PassValue.otp)
        // MARK: - Change Border Color TextField Delegate
        otpTextField.delegate = self
        otpTextField.underlines[0].backgroundColor = UIColor._lightningYellow
        otpTextField.becomeFirstResponder()
        otpTextField.keyboardType = .phonePad
        otpTextField.font = UIFont(name:"SourceSansPro-Bold",size:20)!
        let numberReplace =  numberDisplayLabel.text!
        numberDisplayLabel.text = numberReplace.replacingOccurrences(of: "+15555555555", with: PassValue.mobile)
        spinnerView.isHidden = true 
    }

    // Mark: - Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension OtpVerificationViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {

    }

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
                spinnerView.isHidden = true
                createUser()
            } else {
                spinnerView.isHidden = true
                self.alert(title: "Error", message: "Your OTP number is wrong", cancel: "Dismiss")
            }
        } else {
                spinnerView.isHidden = true
                self.alert(title: "Error", message: "Please Check Your Internet Connection", cancel: "Dismiss")
        }
    }

    // MARK: - Create User API
    func createUser() {
        let user = PFUser()
        user["username"] = PassValue.mobile
        user.password = PassValue.mobile
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
    }

    // MARK: - Old User
    func oldUser() {
        PFUser.logInWithUsername(inBackground: PassValue.mobile, password:PassValue.mobile) { (user, error) in
            if user != nil {
                User.firstLogin = false
                self.login()
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }

    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    // MARK: - Resend OTP Action
    @IBAction func resendOTPAction(_ sender: Any) {
        PassValue.otp = self.generateRandomDigits(6)
        let parameters = ["From": API.twilioFromNumber, "To":  "+1\(PassValue.mobile)", "Body": "Platedate OTP code is \(PassValue.otp)"]
        Alamofire.request(API.twilioUrl, method: .post, parameters: parameters)
        .authenticate(user: API.twilioAccountSID, password: API.twilioAuthToken)
        .responseString { response in
            print(response)
        }
        RunLoop.main.run()
    }
}
