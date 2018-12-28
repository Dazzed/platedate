//
//  MobileLoginViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 06/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit


class MobileLoginViewController: UIViewController, UITextFieldDelegate {

    // Mark: - @IBOutlets
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var alertLabelBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Mark: - Keyboard Notification
        keyBoardNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Mark: - Keyboard Appear
        mobileTextField.becomeFirstResponder()
        // Mark: - Delegate
        mobileTextField.delegate = self
    }
    
    func keyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(MobileLoginViewController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MobileLoginViewController.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

     // Mark: - Keyboard Show Notification
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
                if self.view.frame.origin.y == 0{
                   // self.view.frame.origin.y -= keyboardSize.height
                   print(keyboardSize.height)
                   KeyBoard.height = keyboardSize.height
                   print(keyboardSize.height)
                   print()
                   switch UIScreen.main.nativeBounds.height {
                case 2436:
                     alertLabelBottomConstraint.constant =  KeyBoard.height + 30
                case 2688:
                    alertLabelBottomConstraint.constant =  KeyBoard.height + 30
                case 1792:
                   alertLabelBottomConstraint.constant =  KeyBoard.height + 30
                default:
                   alertLabelBottomConstraint.constant =  KeyBoard.height + 20
                }
            }
        }
    }

    // Mark: - Keyboard Hide Notification
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                //self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func verifyButtonAction(_ sender: Any) {
        verify()
    }

    // Mark: - Verify
    func verify() {
        guard var mobile = mobileTextField.text?.trimmingCharacters(in: .whitespaces) else {return}
        let fieldUpdate = !mobile.isEmpty
        // Mark: - Mobile Format Replace
        mobile = mobile.replacingOccurrences(of: " ", with: "")
        mobile = mobile.replacingOccurrences(of: ")", with: "")
        mobile = mobile.replacingOccurrences(of: "(", with: "")

        if fieldUpdate {
            APIClient.shared.mobileLogin(mobile: mobile, completion: { (success, error) in
                if success {
                    PassValue.mobile = mobile
                    self.navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.otpVerificationStoryBoardId)
                    print(User.message)
                } else {
                   self.alert(title: "Error!", message: User.message, cancel: "Dismiss")
                }
            })
         } else {
            alert(title: "Mobile Field is Empty", message: "Please Enter Valid Mobile Number", cancel: "Dismiss")
        }
    }

    func veriyAPI() {
            
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,  replacementString string: String) -> Bool {
        let str = (mobileTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == mobileTextField {
            print("works")
            return checkFormat(string: string, str: str)
        } else {
            return true
        }
    }

    func checkFormat(string: String?, str: String?) -> Bool{
        if string == ""{
            return true
        } else if str!.count < 3{
            if str!.count == 1{
                mobileTextField.text = "("
            }
        } else if str!.count == 5{
            mobileTextField.text = mobileTextField.text! + ") "
        } else if str!.count == 10{
            mobileTextField.text = mobileTextField.text! + " "
        } else if str!.count > 14{
            return false
        }
        return true
    }
}
