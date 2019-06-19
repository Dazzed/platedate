////
////  AuthenticationInfo.swift
////  PlateDate
////
////  Created by WebCrafters on 03/12/18.
////  Copyright © 2018 WebCrafters. All rights reserved.
////
//
//import UIKit
////import Alamofire
//import SwiftyJSON
//import RealmSwift
//
//class AuthenticationInfo:Object {
//    @objc dynamic var status = ""
//    @objc dynamic var user_id = ""
//    @objc dynamic var confirmation_code = ""
//    @objc dynamic var message = ""
////194080ee-199c-4752-96ac-786081025487
//
//     static func current() -> AuthenticationInfo? {
//        let realm = try! Realm()
//        return realm.objects(AuthenticationInfo.self).first
//    }
//
//    // Mark: - Retrive FaceBook Details
//    static func retriveFBData(_ dict: [String:Any]) {
//        if let id = dict["id"] as? String {
//            User.Facebook.id = id
//        }
//
//         if let email = dict["email"] as? String {
//            print(email)
//            User.Facebook.email = email 
//        }
//
//        if let name = dict["name"] as? String {
//            print(name)
//            User.Facebook.name = name
//        }
//
//        if let location = (((dict as [String : AnyObject])["location"]! as? [String: Any])?["location"] as? [String: Any])?["city"]! as? String {
//            print(location)
//            User.Facebook.location = location
//        }
//
//        if let gender = dict["gender"] as? String {
//            print(gender)
//            User.Facebook.gender = gender
//        }
//
//        if let imageUrl = (((dict as [String : AnyObject])["picture"]! as? [String: Any])?["data"] as? [String: Any])?["url"]! as? String {
//            User.Facebook.imageUrl = imageUrl
//            print(imageUrl)
//        }
//    }
//
//    // Mark: - Retrive mobile Login
//    static func retriveMobileLogin(_ dict: [String:Any]) {
//        if let message = dict["message"] as? String {
//            User.message = message
//        }
//    }
//
//    // Mark: - Retrive OTP
//     static func retriveOTPVerify(_ dict: [String:Any]) {
//
//         if let id = dict["id"] as? Int {
//            User.id = id
//        }
//
//        if let email = dict["email"] as? String {
//            User.email = email
//        }
//
//        if let mobile = dict["contactNumber"] as? String {
//            User.mobile = mobile
//        }
//
//         if let mobileVerified = dict["mobileOtpVerified"] as? Bool {
//            User.mobileVerified = mobileVerified
//        }
//
//        if let firstLogin = dict["firstLogin"] as? Bool {
//            User.firstLogin = firstLogin
//        }
//    }
//
//    // Mark: - Retrive Facebook
//    static func faceBookData(_ dict: [String:Any]) {
//
//        if let email = dict["email"] as? String {
//            User.email = email
//        }
//
//        if let emailVerified = dict["emailVerified"] as? Bool {
//            User.emailVerified = emailVerified
//        }
//
//        if let id = dict["id"] as? Int {
//            User.id = id
//        }
//
//        if let firstLogin = dict["firstLogin"] as? Bool {
//            User.firstLogin = firstLogin
//        }
//
//        if let profileName = dict["profileName"] as? String {
//            User.profileName = profileName
//        }
//    }
//
//     // Mark: - Retrive Eamil Verify
//      static func emailVerifyData(_ dict: [String:Any]) {
//        if let emailVerified = dict["emailVerified"] as? Bool {
//            print(emailVerified)
//            User.emailVerified = emailVerified
//        }
//
//         if let firstLogin = dict["firstLogin"] as? Bool {
//            User.firstLogin = firstLogin
//        }
//
//          if let id = dict["id"] as? Int {
//            User.id = id
//        }
//
//         if let email = dict["email"] as? String {
//            User.email = email
//        }
//
//    }
//}
//
//
//class RecipeInfo:Object {
//
//     static func current() -> RecipeInfo? {
//        let realm = try! Realm()
//        return realm.objects(RecipeInfo.self).first
//    }
//
//     static func getRecipeData(_ dict: [String:Any]) {
//
//        if let image_link = dict["image_link"] as? String {
//            getRecipe.recipeImageLink = image_link
//        }
//
//        if let userId = dict["userId"] as? String {
//            User.id = Int(userId)!
//        }
//
//         if let recipeMode = dict["private"] as? String {
//             getRecipe.recipeMode = recipeMode
//        }
//
//         if let title = dict["title"] as? String {
//            getRecipe.recipeTitle = title
//        }
//
//         if let description = dict["description"] as? String {
//            getRecipe.recipeDescription = description
//        }
//
//         if let cookware = dict["cookware"] as? Array<Any> {
//            print(cookware)
//          getRecipe.recipeCookWareArray = cookware as! [String]
//        }
//
//         if let ingredient = dict["ingredient"] as? Array<Any> {
//            getRecipe.recipeIngredientArray = ingredient as! [String]
//        }
//
//          if let ingredientAmount = dict["ingredientAmount"] as? Array<Any> {
//            getRecipe.recipeIngredientAmountArray = ingredientAmount as! [String]
//        }
//
//        if let prepTime = dict["prepTime"] as? String {
//            getRecipe.prepatationTime = prepTime
//        }
//
//          if let servings = dict["servings"] as? String {
//            getRecipe.servings = servings
//        }
//
//         if let steps = dict["steps"] as? Array<Any> {
//            getRecipe.recipeAddStepArray = steps as! [String]
//        }
//     }
//
//
//     static func recipeDisplayData(_ dict: [String:Any]) {
//
//         if let title = dict["title"] as? String {
//            print(title)
//        }
//
//        if let link = dict["link"] as? String {
//
//        }
//
//          if let userId = dict["userId"] as? String {
//
//        }
//
//
//        if let createdTime = dict["createdTime"] as? String {
//
//        }
//
//
//        if let user = dict["user"] as? [String:Any] {
//            print(user)
//        }
//    }
//}
//
//
////[
////  {
////    "title": "",
////    "userId": 1,
////    "link": "https://platedate.s3.ap-south-1.amazonaws.com/1547296240861",
////    "createdTime": null,
////    "user": {
////      "profileName": "ss",
////      "fbProfile": {
////        "id": "170511473906543",
////        "name": "Vignesh",
////        "email": "vignesh.j1995543@gmail.com",
////        "picture": {
////          "data": {
////            "height": 50,
////            "is_silhouette": false,
////            "url": "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=170511473906543&height=50&width=50&ext=1549196359&hash=AeTRPWEeOQvG5u5L",
////            "width": 50
////          }
////        }
////      },
////      "id": 1
////    }
////  },
//
//
//
//
//
//
//
//
////  "image_link": "https://platedate.s3.amazonaws.com/1547100455557.jpeg",
////  "private": "0",
////  "title": "sdasd",
////  "description": "sdsd",
////  "cookware": [
////    "1",
////    "2"
////  ],
////  "ingredient": [
////    "1",
////    "2"
////  ],
////  "ingredientAmount": [
////    "1",
////    "2"
////  ],
////  "prepTime": "2",
////  "servings": "3",
////  "steps": [
////    "1",
////    "2"
////  ]
////}

