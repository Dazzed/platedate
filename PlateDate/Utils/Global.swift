//
//  Global.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

struct ViewController {

    // Mark: - StoryBoard Name
    struct StroyBoardName {
        static let authentication = "Auth"
        static let dashBaord = "DashBoard"
        static let profileInfo = "ProfileInfo"
        static let recipeDetail = "RecipeDetail"
    }

    // Mark: - Class Name
    struct Class {

        // Mark: - Auth
        static let login = "LoginViewController"
        static let mobileLogin = "MobileLoginViewController"
        static let otpVerfication = "OtpVerificationViewController"
        static let eamilLogin = "EmailLoginViewController"
        static let checkEmail = "CheckEmailViewController"

        // Mark: - Profile Info
        static let Slide = "Slide"
        static let swipe = "SwipeViewController"

        // Mark: - DashBaord
        static let pageController = "Page"
    }

    // Mark: - StoryBoard ID
    struct StoryBoardId {
        // Mark: - Auth StoryBoard
        static let loginStoryBoardId = "Login"
        static let mobileLoginStoryBoardId = "MobileLogin"
        static let otpVerificationStoryBoardId = "OtpVerification"
        static let emailLoginStoryBoardId = "EmailLogin"
        static let checkEmailStoryBoardId = "CheckEmail"
        static let swipeStoryBoardId = "Swipe"

        // Mark: - DashBaord StoryBoard
        static let pageControllerStoryBoardId = "CheckEmail"


        // Mark: - DashBaord StoryBoard
        static let homeStoryBoardId = "Home"
    }
}

// Mark: - TableView Controller
 struct TableViewController {
    static let trending = "TrendingRecipiesTableViewController"
    static let following = "FollowingRecipesTableViewController"
}


// Mark: - TableView
struct TableViewCell {

    // Mark: - TableView Class
    struct ClassName {
        static let trending = "TrendingRecipiesTableViewCell"
        static let following = "FollowingRecipiesTableViewCell"
        static let dieatary = "DieataryTableViewCell"
        static let allergies = "AllergiesTableViewCell"
    }

    // Mark: - TableView ReuseIdentifier
    struct ReuseIdentifier {
        static let trending = "TrendingCell"
        static let following = "FollowingCell"
        static let dieatary = "DieataryCell"
        static let allergies  = "AllergiesCell"
    }
}

// Mark: - XIB
struct XibName {
    static let callNameView = "CallNameView"
    static let userNameView = "UserNameView"
    static let dieatrayRestrictionView = "DietaryRestrictionsView"
    static let allergiesView = "AllergiesView" 
}

// Mark: - Keyboard
struct KeyBoard {
    static var height:CGFloat = 233.0
}

// Mark: - TabBar
struct TabBar {
    static let tabBarStoryBoardId = "TabBar"
}


