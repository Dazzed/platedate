//
//  APIClient.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import FBSDKLoginKit

class APIClient:UIViewController {

    static let shared = APIClient()
    
     // MARK: - Login
    func loginUser(phone:String,password:String, completion: @escaping (Bool, Error?) ->Void) {
        let url = API.Users.login_path
        let parameter: Parameters = [API.loginFields.phone:phone, API.loginFields.password:password]
        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            let validation = self.validate(response)
            guard validation.status, let _: [String:Any] = validation.dict else {
                return completion (false, validation.error)
            }
            User.message = response.result.value as! String
            // AuthenticationInfo.addSignInUser(dict)
             //UserDefaults.standard.set(true, forKey: "auto_login")
             completion(true,nil)
        }
    }

    // MARK: - Email Login
    func emailLogin(email:String, completion: @escaping (Bool, Error?) ->Void) {
        let url = API.Users.emailPath
        let parameter: Parameters = [API.emailLloginFields.email:email] 
        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            let validation = self.validate(response)
            if validation.status != true {
                return completion (false, validation.error)
            }
             completion(true,nil)
        }
    }

    // MARK: - Mobile Login
    func mobileLogin(mobile:String, completion: @escaping (Bool, Error?) ->Void) {
        let url = API.Users.mobilePath
        let parameter: Parameters = [API.mobileLoginFields.mobile:mobile]
        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            let validation = self.validate(response)
            print(response)
            guard validation.status, let dict: [String:Any] = validation.dict else {
                return completion (false, validation.error)
            }
            AuthenticationInfo.retriveMobileLogin(dict)
             completion(true,nil)
        }
    }

    // MARK: - OTP Verify
    func otpVerify(mobile:String, otp:Double, completion: @escaping (Bool, Error?) ->Void) {
       let url = API.Users.otpPath
       let parameter: Parameters = [API.otpVerifyFields.mobile:mobile, API.otpVerifyFields.otp:otp]
        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            let validation = self.validate(response)
            print(response)
            guard validation.status, let dict: [String:Any] = validation.dict else {
                return completion (false, validation.error)
            }
            AuthenticationInfo.retriveOTPVerify(dict)
             completion(true,nil)
        }
    }

     // MARK: - SignUp
    func faceBookUser(completion: @escaping  (Bool,Error?) -> Void) {
        let url = API.faceBookUrl
         let parameter:Parameters =  [API.faceBookFields.name: User.Facebook.name, API.faceBookFields.profileUrl: User.Facebook.imageUrl, API.faceBookFields.email: User.Facebook.email, API.faceBookFields.verified: User.Facebook.verified, API.faceBookFields.locale: User.Facebook.location, API.faceBookFields.updatedTime: "10", API.faceBookFields.timezone: "10",API.faceBookFields.authToken:User.Facebook.authToken ]
        AlamofireManagaer.request(url, method: HTTPMethod.post, parameters:parameter, encoding:URLEncoding.default) { (response) -> Void in
            let validation = self.validate(response)
            print(response)
            guard validation.status, let dict: [String:Any] = validation.dict else {
                return completion (false, validation.error)
            }
                print(dict)
           // AuthenticationInfo.addSignUpUser(dict)
            completion(true,nil)
        }
    }

    func faceBookLogin(phone:String,password:String, completion: @escaping (Bool, Error?) ->Void) {
        let url = API.Users.login_path
        let parameter: Parameters = [API.loginFields.phone:phone, API.loginFields.password:password]
        AlamofireManagaer.request(url, method: .post, parameters: parameter, encoding: URLEncoding(destination: .httpBody)) { (response) -> Void in
            let validation = self.validate(response)
            guard validation.status, let _: [String:Any] = validation.dict else {
                return completion (false, validation.error)
            }
        // AuthenticationInfo.addSignInUser(dict)
        //UserDefaults.standard.set(true, forKey: "auto_login")
        completion(true,nil)
        }
    }

     //MARK: - Helper methods
    func validate(_ response: DataResponse<Any>) -> (status: Bool, error: Error?, dict: [String: Any]?) {
        let dict = response.result.value as? [String: Any]

        guard (response.response?.statusCode == 200) else {
            return (false, response.result.value as? Error, nil)
        }

        return (true, nil, dict)
    }
}

// MARK: - API Error
enum APIError: Error {
    case errorMessage(String?)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .errorMessage(let message):
            let text = message ?? ""
            return NSLocalizedString(text, comment: "")
        }
    }
}

//// MARK: - SignUp
//    func faceBookUser(name:String,profileUrl:String,email:String,verified:Bool,locale:String,updatedTime:String,timezone:String,  completion: @escaping  (Bool,Error?) -> Void) {
//        let url = API.faceBookUrl
//        let parameter:Parameters = [API.faceBookFields.name:name ,API.faceBookFields.profileUrl:profileUrl,  API.faceBookFields.email:email, API.faceBookFields.verified:verified, API.faceBookFields.locale:locale, API.faceBookFields.updatedTime: updatedTime, API.faceBookFields.timezone: timezone]
//        AlamofireManagaer.request(url, parameters:parameter, encoding:URLEncoding(destination: .httpBody)) { (response) -> Void in
//            let validation = self.validate(response)
//            guard validation.status, let dict: [String:Any] = validation.dict else {
//                return completion (false, validation.error)
//            }
//                print(dict)
//           // AuthenticationInfo.addSignUpUser(dict)
//            completion(true,nil)
//        }
//    }
