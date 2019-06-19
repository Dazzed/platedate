////
////  ProfileInfo.swift
////  PlateDate
////
////  Created by WebCrafters on 03/01/19.
////  Copyright © 2019 WebCrafters. All rights reserved.
////
//
//import UIKit
////import Alamofire
//import SwiftyJSON
//import RealmSwift
////z
//class profileInfo:Object {
//    @objc dynamic var status = ""
//    @objc dynamic var user_id = ""
//    @objc dynamic var confirmation_code = ""
//    @objc dynamic var message = ""
////194080ee-199c-4752-96ac-786081025487
//
//     static func current() -> profileInfo? {
//        let realm = try! Realm()
//        return realm.objects(profileInfo.self).first
//    }
//
//    // Mark: - Retrive Eamil Verify
//      static func profileDict(_ dict: [String:Any]) {
//
//        if let email = dict["email"] as? String {
//            User.email = email
//        }
//
//         if let mobile = dict["mobile"] as? String {
//            User.email = mobile
//        }
//
//        if let id = dict["id"] as? Int {
//            User.id = id
//        }
//
//        if let profileName = dict["profileName"] as? String {
//            User.profileName = profileName
//        }
//
//          if let userName = dict["userName"] as? String {
//            User.userName = userName
//        }
//    }
//}
