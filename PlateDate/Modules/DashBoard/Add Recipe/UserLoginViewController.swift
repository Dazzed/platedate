//
//  UserLoginViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 11/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import EasyPopUp
import FBSDKLoginKit
//import Alamofire

class UserLoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var popupContentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.navigationController)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Phone Button Action
    @IBAction func phoneButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.mobileLoginStoryBoardId)
    }

    // MARK: - Email Button Action
    @IBAction func emailButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.emailLoginStoryBoardId)
    }

    // MARK: - MaybeLater Button Action
    @IBAction func mayBeLaterButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.dashBaord, storyBoardId: ViewController.StoryBoardId.homeStoryBoardId)
    }

     @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

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
                    _ = result as! [String : AnyObject]
                    User.Facebook.authToken = FBSDKAccessToken.current().tokenString
                    print(User.Facebook.authToken)
                    //AuthenticationInfo.retriveFBData(dict)
                   // self.facbookAPI()
                } else {
                    print(error?.localizedDescription ?? "")
                }
            })
        }
    }
}

extension UserLoginViewController : EasyPopUpViewControllerDatasource {
    var popupView: UIView {
        return popupContentView
    }
}
