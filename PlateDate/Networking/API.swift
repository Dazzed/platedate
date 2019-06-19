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
    static let baseUrl = "https://plate-date.herokuapp.com/api/"
    static let photoUrl = ""
    static let faceBookUrl = "https://plate-date.herokuapp.com/auth/facebook"

    // MARK: - Twilio (Mobile OTP)
    static let twilioAccountSID = "AC9122a996671853e5904d37f49cae2527"
    static let twilioAuthToken = "00c91c526e96ef665aed7cfafb1b8814"
    static let twilioFromNumber = "+15802719668"
    static let twilioUrl = "https://api.twilio.com/2010-04-01/Accounts/\(API.twilioAccountSID)/Messages"

     // MARK: - SendGrid (Email OTP)
    static let sendGridAPIKey = "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"
    static let sendGridFromEmail = "info@platedate.com"

    struct Users {
        // MARK: - Authentication Path
        static let facebookPath = "\(baseUrl)users/facebookRegistration"
        static let emailPath = "\(baseUrl)users/postSignupEmail"
        static let mobilePath = "\(baseUrl)users/sendMobileOtp"
        static let otpPath = "\(baseUrl)users/verifyMobileOtp"
        static let emailVerifyPath = "\(baseUrl)users/verifyEmail"

        // MARK: - Profile
        static let profileInfoPath = "\(baseUrl)users/userProfileData"

        // MARK: - Profile
        static let addRecipe = "\(baseUrl)Recipes/addRecipe"
        static let getRecipe = "\(baseUrl)Recipes/getRecipe"
        static let editRecipe = "\(baseUrl)Recipes/editRecipe"
    }

//------------ Authentication Fields ------------//

    // MARK: Authentication Fields
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

    struct eamilVerifyFields {
        static let email = "email"
        static let verificationCode = "verificationCode"
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
        static let authToken = "oauth-token"
    }

//------------ Authentication Fields ------------//


//------------ Profile Fields ------------//

 // MARK: - ProfileInfoFields Fields

   struct profileInfoFields {
      //  static let id = "id"
        static let id = "id"
        static let profileName = "profileName"
        static let userName = "userName"
        static let dietaryRestrictions = "dietaryRestrictions"
        static let allergies = "allergies"
    }

//------------ profileInfoFields Fields ------------//

 // MARK: - AddRecipeFields Fields
    struct addRecipeFields {
        static let recipeId = "id"
        static let userId = "userId"
        static let privateRecipe = "private"
        static let title = "title"
        static let description = "description"
        static let servings = "servings"
        static let cookware = "cookware"
        static let ingredient = "ingredient"
        static let ingredientAmount = "ingredientAmount"
        static let prepTime = "prepTime"
        static let file = "file"
        static let steps = "steps"
    }

     struct editRecipeFields {
        static let recipeId = "recipeId"
    }
    
    // MARK: - Fields
     struct ResultsFields {
        // MARK: - Login
        static let status = "Response Code"
        static let message = "message"
    }
}
