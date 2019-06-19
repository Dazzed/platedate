//
//  EditProfileViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 08/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import Parse
import ImagePicker
import Photos
class EditProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, ImagePickerDelegate {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioCharacterCountLabel: UILabel!
    var changeImage:Bool = false

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserValues()
        delegates()
        hideKeyboardWhenTappedAround()
        LoadSpinnerView()
    }

    func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    func delegates() {
        nameTextField.delegate = self
        usernameTextField.delegate = self
        locationTextField.delegate = self
        websiteTextField.delegate = self
        bioTextView.delegate = self
    }

    func getUserValues() {
        spinnerView.isHidden = false
        let user = PFUser.current()!
        usernameTextField.text = user["userDisplayName"] as? String
        nameTextField.text = user["profileName"] as? String

        if user["location"] != nil {
            locationTextField.text = user["location"] as? String
        } else {
            locationTextField.text = ""
        }

        if user["link"] != nil {
            websiteTextField.text =  user["link"] as? String
        } else {
            websiteTextField.text = ""
        }

        if user["bio"] != nil {
            bioTextView.text =  user["bio"] as? String
        } else {
            bioTextView.text = ""
        }

        bioCharacterCountLabel.text = String("\(bioTextView.text.count)/300 characters")

        let loadImageParams = LoadImageParams(showActivityIndicator: false)

        if user["profileImage"] == nil {
            if user["profilePicture"] == nil {
                profileImageView.image = #imageLiteral(resourceName: "Profile")
            } else {
                profileImageView.loadImage(fromUrl: user["profilePicture"] as? String , withParams: loadImageParams, completion: nil)
            }
        } else {
            let profileImageFile = user["profileImage"] as? PFFileObject
            profileImageView.loadImage(fromUrl: profileImageFile?.url , withParams: loadImageParams, completion: nil)
        }

        spinnerView.isHidden = true
    }

    func save() {
        spinnerView.isHidden = false
        let user = PFUser.current()!
        user["profileName"] = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        user["userDisplayName"] = usernameTextField.text?.trimmingCharacters(in: .whitespaces)
        user["location"] = locationTextField.text?.trimmingCharacters(in: .whitespaces)
        user["link"] = websiteTextField.text?.trimmingCharacters(in: .whitespaces)
        user["bio"] = bioTextView.text?.trimmingCharacters(in: .whitespaces)

         if changeImage == true {
            //Mark : - Save Image
            if profileImageView.image != nil {
                let imageData = UIImageJPEGRepresentation(profileImageView.image!, 0.5)
                let imageFile = PFFileObject(name:"avatar.jpg", data:imageData!)
                user["profileImage"] = imageFile
                User.userProfileImage = profileImageView.image 
            }


        }

        user.saveInBackground(block: { (success, error) in
            if (success) {
                self.spinnerView.isHidden = true
                self.alert(title: "Success", message: "profile information updated successfully", cancel: "Ok")
            } else {
                 self.spinnerView.isHidden = true
                print(error ?? "Server error")
            }
        })
    }

    // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func doneButtonAction(_ sender: Any) {
        save()
    }

      //Mark: - TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField == nameTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

        if textField == usernameTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

        if textField == locationTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

        if textField == websiteTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
        return true
    }

    //Mark: - TextView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == bioTextView {
            if range.location == 0 {
                let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            } else {
                if(textView.text.count > 299) {
                    print("Please summarize in 300 characters or less")
                    return false
                }
            }
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {

        if textView == bioTextView {
             bioCharacterCountLabel.text = String("\(textView.text.count)/300 characters")
             print("Please summarize in 50 characters or less")
        }
    }

    //Mark: - Get image from Gallery
    @IBAction func imgaePickerButtonAction(_ sender: Any) {
        print("button working.....")
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
}

 extension EditProfileViewController {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {

    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count != 0 {
            profileImageView.image = images[0]
            changeImage = true
            self.dismiss(animated: true, completion: nil)
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
