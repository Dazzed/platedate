//
//  API.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

struct  API {
//https://plate-date.herokuapp.com/api/users/
     // MARK: - Path
    static let baseUrl = "https://plate-date.herokuapp.com/api/users/"
    static let photoUrl = ""
    static let faceBookUrl = "https://plate-date.herokuapp.com/auth/facebook"

    // MARK: - Authentication Path
    struct Users {
        static let login_path = "\(baseUrl)User/login"
        static let emailPath = "\(baseUrl)postSignupEmail"
        static let mobilePath = "\(baseUrl)sendMobileOtp"
        static let otpPath = "\(baseUrl)verifyMobileOtp"
    }

    // MARK: - Authentication Fields
    struct emailLloginFields {
        static let email = "email"
    }

     struct mobileLoginFields {
        static let mobile = "contactNumber"
    }

    struct otpVerifyFields {
        static let mobile = "contactNumber"
        static let otp = "otp_to_verify"
    }


    struct loginFields {
        static let phone = "phone"
        static let password = "password"
    }

    struct faceBookFields {
      //  static let id = "id"
        static let name = "name"
        static let profileUrl = "link"
        static let gender = "gender"
        static let email = "email"
        static let verified = "verified"
        static let locale = "locale"
        static let updatedTime = "updated_time"
        static let timezone = "timezone"
        static let authToken = "authToken"
    }

    // MARK: - Fields
     struct ResultsFields {
        // MARK: - Login
        static let status = "Response Code"
        static let message = "message"
    }
}
