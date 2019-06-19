//
//  DashBoard.swift
//  PlateDate
//
//  Created by WebCrafters on 12/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import Parse

// Mark: - RecipeData (HomePage)
class Recipe:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeDescription:String = ""
    var recipeCreateTime:String = ""
    var recipeImageUrl:String = ""
    var bookMark:String = ""
    var recipeUserName:String = ""
    var recipeUserobjectId:String = ""
    var recipeUserImageUrl:String = ""
    var user = PFUser()

    init (recipeObjectId:String, recipeTitle:String, recipeDescription:String, recipeCreateTime:String, recipeImageUrl:String, recipeUserName:String, bookMark:String, recipeUserobjectId:String, recipeUserImageUrl:String, user:PFUser)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeDescription = recipeDescription
        self.recipeCreateTime = recipeCreateTime
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserName = recipeUserName
        self.bookMark = bookMark
        self.recipeUserobjectId = recipeUserobjectId
        self.recipeUserImageUrl = recipeUserImageUrl
        self.user = user 
    }
}

struct DashBoardArray {
    static var bookMark = [String]()
    static var bookMarkString:String = ""
    static var removeBookMark:String = ""
}

struct DashBoard {
    static var bookMark:String!
    static var bookMarkIndex:Int!
}

struct RecipeArray {
    static var recipeDisplay = [Recipe]()
}

// Mark: - RecipeDetails
struct RecipeDetail {
    static var recipeObjectId:String =  ""
    static var recipeImageUrl:String =  ""
    static var recipeTitle:String =  ""
    static var recipeDescription:String =  ""
    static var preparationTime:String =  ""
    static var servings:String =  ""
    static var cookWareArray = [String]()
    static var ingredientArray = [String]()
    static var ingredientAmountArray = [String]()
    static var preparationArray = [String]()
    static var recipeUserName:String =  ""
    static var nutritionFacts =  [[String:AnyObject]]()
    static var commentsBool:Bool = false
    static var recipeUserObjectId:String =  ""
    static var recipeUserimageUrl:String =  ""
}

// Mark: - AddToCollection
struct AddToCollection {
    static var collectionNameArray = ["New Collection"]
    static var addBoolArray = [false]
}

// Mark: - Comments
class Comments:NSObject {
     var profileImageUrl:String = ""
     var username:String = ""
     var rating:Double = 0.0
     var commentImageUrl:String = ""
     var comment:String = ""
     var time:String = ""
     var replyCount:Int = 0
     var likeCount:Int = 0
     var commentObjectID:String = ""
     var likeCommentBool:Bool = false
     var userObjectId:String = ""
     var commentUserImageUrl:String = ""

    init (profileImageUrl:String, username:String, rating:Double, commentImageUrl:String, comment:String, time:String, replyCount:Int, likeCount:Int,commentObjectID:String, likeCommentBool:Bool, userObjectId:String,commentUserImageUrl:String) {
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.rating = rating
        self.commentImageUrl = commentImageUrl
        self.comment = comment
        self.time = time
        self.replyCount = replyCount 
        self.likeCount = likeCount 
        self.commentObjectID = commentObjectID
        self.likeCommentBool = likeCommentBool
        self.userObjectId = userObjectId
        self.commentUserImageUrl = commentUserImageUrl
    }
}

struct CommentsArray {
    static var comments = [Comments]()
}

// Mark: - ViewCollection
class Collection:NSObject {

    var collectionName:String = ""
    var collectionBoolArray:Bool = false
    var collectionObjectId:String = ""
    var recipeImageUrl:String = ""
    var recipeUserObjectId:String = ""

    init (collectionName:String, collectionBoolArray:Bool, collectionObjectId:String, recipeImageUrl:String, recipeUserObjectId:String)    {
        self.collectionName = collectionName
        self.collectionBoolArray = collectionBoolArray
        self.collectionObjectId = collectionObjectId
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserObjectId = recipeUserObjectId
    }
}

struct CollectionArray {
    static var collection = [Collection(collectionName: "New Collection", collectionBoolArray: false, collectionObjectId: "id", recipeImageUrl: "", recipeUserObjectId:(PFUser.current()?.objectId!)!)] 
}

// Mark: - ViewCollection
class Reply:NSObject {

    var userName:String = ""
    var reply:String = ""
    var replyTime:String = ""
    var likeCount:Double = 0
    var replyUserImageUrl:String = ""

    init (userName:String, reply:String, replyTime:String, likeCount:Double, replyUserImageUrl:String)    {
        self.userName = userName
        self.reply = reply
        self.replyTime = replyTime
        self.likeCount = likeCount
        self.replyUserImageUrl = replyUserImageUrl
    }
}

struct ReplyArray {
    static var reply = [Reply]()
}


// Mark: - ViewCollection
class SearchRecipe:NSObject {

    var searchRecipeName:String = ""
    var searchRecipeObjectId:String = ""
    var searchRecipeImageUrl:String = ""

    init (searchRecipeName:String, searchRecipeObjectId:String, searchRecipeImageUrl:String) {
        self.searchRecipeName = searchRecipeName
        self.searchRecipeObjectId = searchRecipeObjectId
        self.searchRecipeImageUrl = searchRecipeImageUrl
    }
}

struct SearchCollectionArray {
    static var collection = [SearchRecipe]()
}







