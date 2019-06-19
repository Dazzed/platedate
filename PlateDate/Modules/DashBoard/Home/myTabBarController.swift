//
//  myTabBarController.swift
//  PlateDate
//
//  Created by WebCrafters on 11/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//
//7hUvSEQc0kbeXwlwQVg4qQVWAfQam3oY0qsXaJDi

import UIKit
import EasyPopUp
import Parse

class myTabBarController: UITabBarController, UITabBarControllerDelegate {

    var popUpConfig = EasyPopupConfig()
    var asss = AddRecipeViewController()

    @IBOutlet weak var myTabBar: UITabBar!

     @IBOutlet var userLoginPopUpView: UIView!

    // Mark: - User Login PopUp
     lazy var userLoginPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: userLoginPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

     // MARK: - Email Button Action
    @IBAction func emailButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.emailLoginStoryBoardId)
    }

    @IBAction func phoneButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.mobileLoginStoryBoardId)
    }

    @IBAction func faceBookButtonAction(_ sender: AnyObject) {
        facebook()
    }

    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        userLoginPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTabBar.invalidateIntrinsicContentSize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("myTabBar.items!\(myTabBar.items!.count)")
        for (i, _) in myTabBar.items!.enumerated() {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136, 1334, 1920, 2208:
                      myTabBar.items![i].imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -8, right: 0)
                      print("sd")
                     //  tabBarItem?.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                    case 2436, 2688, 1792:
                    myTabBar.items![i].imageInsets = UIEdgeInsets(top: 14, left: 0, bottom: -20, right: 0)
                        print("sd")
                    default:
                        print("Unknown")
                }
            }
        }
    }

    // Mark: Root page displays when click the tab bar button
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index : Int = tabBarController.viewControllers?.index(of: viewController) ?? 0

        if PFUser.current()?.objectId == nil {
            print("User Does not login")

            if index == 2 || index == 3 || index == 4 {
                print("popUpcreate")

            } else {
                let yourView = self.viewControllers![index] as! UINavigationController
                yourView.popToRootViewController(animated: false)
            }
        } else {
            let yourView = self.viewControllers![index] as! UINavigationController
            yourView.popToRootViewController(animated: false)

            Profile.user = "sameUser"
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         if PFUser.current()?.objectId == nil {
            if viewController == tabBarController.viewControllers?[1] || viewController == tabBarController.viewControllers?[2] || viewController == tabBarController.viewControllers?[3] || viewController == tabBarController.viewControllers?[4] {
                userLoginPopUp.config = popUpConfig
                userLoginPopUp.showPopup { (isfinished) in
                    print(isfinished)
                }

                return false
            } else {
                return true
            }
         } else {
            return true
        }
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate = self
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")

         if item == myTabBar.items![1] {
           if PFUser.current()?.objectId == nil {
                PassValue.indexTapped = false
            } else {
                PassValue.indexTapped = true
            }
        }
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


//       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//       print("Tabbar controll action")
//
//        if tabBarController.selectedIndex == 2 {
//            print("User Does not login")
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
