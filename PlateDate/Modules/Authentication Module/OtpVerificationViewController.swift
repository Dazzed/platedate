//
//  MobileVerificationViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 06/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class OtpVerificationViewController: UIViewController, UITextFieldDelegate {

    // Mark: - @IBOutlets
    @IBOutlet weak var otpTextField: PinCodeTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // MARK: - Change Border Color TextField Delegate
        otpTextField.delegate = self
        otpTextField.underlines[0].backgroundColor = UIColor._lightningYellow
        otpTextField.becomeFirstResponder()
        otpTextField.keyboardType = .phonePad
        otpTextField.font = UIFont(name:"SourceSansPro-Bold",size:20)!
    }

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

    func OTPVerify() {
        guard let otp = otpTextField.text?.trimmingCharacters(in: .whitespaces) else {return}
        print(otp)
        APIClient.shared.otpVerify(mobile: PassValue.mobile, otp: Double(otp)!,  completion: { (success, error) in
            if success {
                self.navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.otpVerificationStoryBoardId)
                print(User.id)
                print(User.email)
                print(User.mobile)
                print(User.emailVerified)
                print(User.mobileVerified)
            } else {
                self.alert(title: "Error", message: "Please Enter Correct OTP Number", cancel: "Dismiss")
                print(User.message)
            }
        })
    }

    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}
