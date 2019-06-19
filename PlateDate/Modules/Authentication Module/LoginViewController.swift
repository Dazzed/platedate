//
//  LoginViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
//import FBSDKLoginKit
//import ParseFacebookUtilsV4
import Parse
//import ParseFacebookUtilsV4



class LoginViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       //  self.tabBarController?.tabBar.backgroundColor = UIColor.clear
      ///  self.tabBarController?.tabBar.isHidden = true
        if UserDefaults.standard.bool(forKey: "login") == true {
             navigationPushAutoRedirect(storyBoardName: ViewController.StroyBoardName.dashBaord, storyBoardId: TabBar.tabBarStoryBoardId)
            PFUser.current()?.objectId =  UserDefaults.standard.string(forKey: "userId")
        }
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.tabBarController?.tabBar.backgroundColor = UIColor.clear
       //self.tabBarController?.tabBar.isHidden = true

       tabBarController?.tabBar.isHidden = true
    edgesForExtendedLayout = UIRectEdge.bottom
    extendedLayoutIncludesOpaqueBars = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //Mark: - Phone Button Action
    @IBAction func phoneButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.mobileLoginStoryBoardId)
    }

    //Mark: - Email Button Action
    @IBAction func emailButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.emailLoginStoryBoardId)
    }

    //Mark: - MayBe Button Action
    @IBAction func mayBeLaterButtonAction(_ sender: Any) {
         navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.dashBaord, storyBoardId: TabBar.tabBarStoryBoardId)
    }
    
    //Mark: - Facebook Button Action
    @IBAction func faceBookButtonAction(_ sender: AnyObject) {
        facebook()
    }

    //Mark: - Facebook Button Action
    func facebook() {
        let permissions = ["public_profile", "email"]
     PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user: PFUser?, error: Error?) in
            if let user = user {
                if user.isNew {
                    User.firstLogin = true
                    self.getData()
                } else {
                    User.firstLogin = false
                    self.login()
                }
            } else {
                print("Uh oh. The user cancelled the    Facebook login.")
            }
        }
    }

    func getData() {
        // Create request for user's Facebook data
        let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
            // Send request to Facebook
        request?.start { (connection, result, error) in
            if error != nil {
                // Some error checking here
            } else if let userData = result as? [String:AnyObject] {
                let id = userData["id"] as? String
                let profilePicUrl = "https://graph.facebook.com/\(id!)/picture"
                let user = PFUser.current()
                user!["profilePicture"] = profilePicUrl
                user?.saveInBackground(block: { (success, error) in
                    if (success) {
                        User.id = (PFUser.current()?.objectId)!
                        self.login()
                    } else {
                        print(error ?? "Server error")
                    }
                })
            }
        }
    }

        //Mark: - Old user
      func oldUser1() {
        let query = PFQuery(className: "Authentication")
        query.whereKey("refKey", equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
            } else {
                for object in objects! {
                    if object["refKey"] as? String == PFUser.current()?.objectId {
                        User.firstLogin = false
                        User.id = object["refKey"] as! String
                        self.login()
                    }
                }
            }
        }
    }

     //Mark: - Upload to SignU  pUser
    func getData1() {
        // Create request for user's Facebook data
        let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
            // Send request to Facebook
        request?.start { (connection, result, error) in
            if error != nil {
                // Some error checking here
            } else if let userData = result as? [String:AnyObject] {
                let id = userData["id"] as? String
                let profilePicUrl = "https://graph.facebook.com/\(id!)/picture"
                let userClass = PFObject(className:"User")
                let authClass = PFObject(className:"Authentication")
                 authClass["profilePicture"] = profilePicUrl
                authClass["refKey"] = PFUser.current()?.objectId
                authClass["relationKey"] = userClass
                authClass["relationKey"] = PFObject(withoutDataWithClassName:"User", objectId:(PFUser.current()?.objectId!))
                authClass.saveInBackground { (success: Bool, error: Error?) in
                    if (success) {
                        User.id = (PFUser.current()?.objectId)!
                        self.login()
                    } else {
                        print(error ?? "Server error")
                    }
                }
            }
        }
    }
}

