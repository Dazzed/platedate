//
//  LoginViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //httpRequest()
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func phoneButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.mobileLoginStoryBoardId)
    }

    @IBAction func emailButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.emailLoginStoryBoardId)
      //httpRequest()
    }


   func httpRequest() {

    //create the url with NSURL
    let url = URL(string: "https://plate-date.herokuapp.com/apple-app-site-association")! //change the url

    //create the session object
    let session = URLSession.shared

    //now create the URLRequest object using the url object
    let request = URLRequest(url: url)

    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

        guard error == nil else {
            return
        }

        guard let data = data else {
            return
        }

        do {
            //create json object from data
            if let data = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                print(data)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    })
    task.resume()
}

//    //Mark: - Login
//    func login() {
//        guard let userName = userNameTextField.text?.trimmingCharacters(in: .whitespaces),
//            let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else {return}
//            let fieldUpdate = !userName.isEmpty && !password.isEmpty
//
//        if fieldUpdate {
//                APIClient.shared.loginUser(phone: userName, password: password, completion: { (success, error) in
//                    if success {
//                       // UIViewController.removeSpinner(spinner: spinnerView)
//                    } else {
//                        //UIViewController.removeSpinner(spinner: spinnerView)
//                    }
//                })
//            } else {
//            if userName.isEmpty {}
//            if password.isEmpty {}
//        }
//    }

    //Mark: - Facebook Button Action
    @IBAction func faceBookButtonAction(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("public_profile")) {
                        self.getFBUserData()
                     }
                }
            }
        }
    }

    //Mark: - Retrive Facebook Info
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender, location{location}"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    let dict = result as! [String : AnyObject]
                    AuthenticationInfo.retriveFBData(dict)
                    self.facbookAPI()
                } else {
                    print(error?.localizedDescription ?? "")
                }
            })
        }
    }

    func facbookAPI() {
        APIClient.shared.faceBookUser(completion: { (success, error) in
            if success {
                print("success")
            } else {
                print(error)
//                self.alert(title: "Error", message: (error?.localizedDescription)!, cancel: "Dismiss")
                print(User.message)
            }
        })

    }

    func faceBookFields() {
            let parameter:Parameters =  [API.faceBookFields.email: User.Facebook.email, API.faceBookFields.authToken:User.Facebook.authToken ]
            Alamofire.request(API.faceBookUrl, parameters: parameter, encoding: URLEncoding(destination: .queryString)).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value)
            }
            break
            case .failure(_):
                print(response.result.error)
                break
            }
        }
    }
}

//
//    func faceBookFields() {
//        APIClient.shared.faceBookUser(name: User.Facebook.name, profileUrl: User.Facebook.imageUrl, email: User.Facebook.email, verified: User.Facebook.verified, locale: User.Facebook.location, updatedTime: "10", timezone: "10", completion: { (success, error) in
//            if success {
//                print(success)
//            } else {
//                print(error)
//            }
//        })
//    }

//        APIClient.shared.faceBookUser(email: User.Facebook.email, completion: { (success, error) in
//            if success {
//                print(success)
//            } else {
//                print(error)
//            }
//        })

//{
//  "email": null,
//  "contactNumber": "9500401937",
//  "emailVerified": false,
//  "mobileOtpVerified": true,
//  "id": 16
//}
