//
//  ProfileData.swift
//  PlateDate
//
//  Created by WebCrafters on 06/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

struct ProfilleRecipeArray {
    static var profileRecipeDisplay = [ProfileRecipe]()
}

// Mark: - RecipeData (HomePage)
class ProfileRecipe:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeDescription:String = ""
    var recipeCreateTime:String = ""
    var recipeImageUrl:String = ""
    var bookMark:String = ""
    var recipeUserName:String = ""
    var recipeUserobjectId:String = ""
    var recipeMode:String = ""
    var recipeUserImageUrl:String = ""

    init (recipeObjectId:String, recipeTitle:String, recipeDescription:String, recipeCreateTime:String, recipeImageUrl:String, recipeUserName:String, bookMark:String, recipeUserobjectId:String, recipeMode:String, recipeUserImageUrl:String)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeDescription = recipeDescription
        self.recipeCreateTime = recipeCreateTime
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserName = recipeUserName
        self.bookMark = bookMark
        self.recipeUserobjectId = recipeUserobjectId
        self.recipeMode = recipeMode
        self.recipeUserImageUrl = recipeUserImageUrl
    }
}

// Mark : - BookMarkView Data
class ProfileBookMark:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeDescription:String = ""
    var recipeCreateTime:String = ""
    var recipeImageUrl:String = ""
    var bookMark:String = ""
    var recipeUserName:String = ""
    var recipeUserobjectId:String = ""
    var recipeUserImageUrl:String = ""

    init (recipeObjectId:String, recipeTitle:String, recipeDescription:String, recipeCreateTime:String, recipeImageUrl:String, recipeUserName:String, bookMark:String, recipeUserobjectId:String, recipeUserImageUrl:String)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeDescription = recipeDescription
        self.recipeCreateTime = recipeCreateTime
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserName = recipeUserName
        self.bookMark = bookMark
        self.recipeUserobjectId = recipeUserobjectId
        self.recipeUserImageUrl = recipeUserImageUrl
    }
}

struct ProfileBookMarkArray {
    static var profileBookMark = [ProfileBookMark]()
}

struct Profile {
    static var bookMarkBool:Bool = false
    static var segmentBool:Bool = false
    static var segmentIndex:Int = 0
    static var user:String = ""
    static var otherUserSegmentBool:Bool = false

}


struct AddProfileBookMark {
    static var recipeObjectId:String = ""
    static var recipeTitle:String = ""
    static var recipeDescription:String = ""
    static var recipeCreateTime:String = ""
    static var recipeImageUrl:String = ""
    static var bookMark:String = ""
    static var recipeUserName:String = ""
    static var recipeUserobjectId:String = ""
    static var recipeUserImageUrl:String = ""
}

struct Setting {
    static var dieatryRestrcition = ["Vegetarian", "Pescetarian", "Vegan", "None"]
    static var dieatryRestrcitionBool = [false, false, false, false]
    static var dieatryAnimationBool:Bool = false
    static var setDieatryRestrcition = 0

    static var allergiesAnimationBool:Bool = false
    static var allergies = ["Dairy", "Egg", "Gluten", "Peanut", "Tree Nut", "Seafood", "Sesame", "Soy", "None"]
    static var allergiesBool = [false, false, false, false, false, false, false, false, false]
    static var setAllergies = ""

    static var measurent = ["U.S.", "Metric"]
    static var measurentAnimationBool:Bool = false
    static var measurentBool = [false, false]
    static var setMeasurent = ""

    static var pushNotification = ["Comments and Replies", "Bookmarks and Ratings"]
    static var pushNotificationAnimationBool:Bool = false
    static var pushNotificationBool = [false, false]
    static var setPushNotification = ""
}


struct OtherUserProfile {
    static var user = PFUser()

}



struct OtherUserProfilleRecipeArray {
    static var profileRecipeDisplay = [OtherUserProfileRecipe]()
}

// Mark: - RecipeData (HomePage)
class OtherUserProfileRecipe:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeDescription:String = ""
    var recipeCreateTime:String = ""
    var recipeImageUrl:String = ""
    var bookMark:String = ""
    var recipeUserName:String = ""
    var recipeUserobjectId:String = ""
    var recipeMode:String = ""
    var recipeUserImageUrl:String = ""

    init (recipeObjectId:String, recipeTitle:String, recipeDescription:String, recipeCreateTime:String, recipeImageUrl:String, recipeUserName:String, bookMark:String, recipeUserobjectId:String, recipeMode:String, recipeUserImageUrl:String)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeDescription = recipeDescription
        self.recipeCreateTime = recipeCreateTime
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserName = recipeUserName
        self.bookMark = bookMark
        self.recipeUserobjectId = recipeUserobjectId
        self.recipeMode = recipeMode
        self.recipeUserImageUrl = recipeUserImageUrl
    }
}

// Mark : - BookMarkView Data
class OtherUserProfileBookMark:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeDescription:String = ""
    var recipeCreateTime:String = ""
    var recipeImageUrl:String = ""
    var bookMark:String = ""
    var recipeUserName:String = ""
    var recipeUserobjectId:String = ""
    var recipeUserImageUrl:String = ""

    init (recipeObjectId:String, recipeTitle:String, recipeDescription:String, recipeCreateTime:String, recipeImageUrl:String, recipeUserName:String, bookMark:String, recipeUserobjectId:String, recipeUserImageUrl:String)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeDescription = recipeDescription
        self.recipeCreateTime = recipeCreateTime
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserName = recipeUserName
        self.bookMark = bookMark
        self.recipeUserobjectId = recipeUserobjectId
        self.recipeUserImageUrl = recipeUserImageUrl
    }

}

    struct OtherUserProfileBookMarkArray {
        static var profileBookMark = [OtherUserProfileBookMark]()
    }

