//
//  AuthenticationInfo.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class AuthenticationInfo:Object {
    @objc dynamic var status = ""
    @objc dynamic var user_id = ""
    @objc dynamic var confirmation_code = ""
    @objc dynamic var message = ""
//194080ee-199c-4752-96ac-786081025487

     static func current() -> AuthenticationInfo? {
        let realm = try! Realm()
        return realm.objects(AuthenticationInfo.self).first
    }

       //Retrive FaceBook
    static func retriveFBData(_ dict: [String:Any]) {
        if let authToken = dict["id"] as? String {
            User.Facebook.authToken = authToken 
        }

         if let email = dict["email"] as? String {
            print(email)
            User.Facebook.email = email 
        }

        if let name = dict["name"] as? String {
            print(name)
            User.Facebook.name = name
        }

        if let location = (((dict as [String : AnyObject])["location"]! as? [String: Any])?["location"] as? [String: Any])?["city"]! as? String {
            print(location)
            User.Facebook.location = location
        }

        if let gender = dict["gender"] as? String {
            print(gender)
            User.Facebook.gender = gender
        }

        if let imageUrl = (((dict as [String : AnyObject])["picture"]! as? [String: Any])?["data"] as? [String: Any])?["url"]! as? String {
            User.Facebook.imageUrl = imageUrl
            print(imageUrl)
        }
    }

    static func retriveMobileLogin(_ dict: [String:Any]) {
        if let message = dict["message"] as? String {
            User.message = message
        }
    }

     static func retriveOTPVerify(_ dict: [String:Any]) {

         if let id = dict["id"] as? Int {
            User.id = id
        }

        if let email = dict["email"] as? String {
            User.email = email
        }

        if let mobile = dict["contactNumber"] as? String {
            User.mobile = mobile
        }

        if let emailVerified = dict["emailVerified"] as? Bool {
            User.emailVerified = emailVerified
        }

         if let mobileVerified = dict["mobileOtpVerified"] as? Bool {
            User.mobileVerified = mobileVerified
        } 

        print(User.Facebook.email)
    }
}

//{
//  "statusCode": 400,
//  "name": "Bad Request",
//  "message": "Mobile number already registered"
//}

//{
//  "message": "OTP send successfully to 8248228376"
//}

//{
//  "email": null,
//  "contactNumber": "8248228376",
//  "emailVerified": false,
//  "mobileOtpVerified": true,
//  "id": 19
//}

