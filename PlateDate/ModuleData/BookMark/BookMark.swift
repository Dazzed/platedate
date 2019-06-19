//
//  BookMark.swift
//  PlateDate
//
//  Created by WebCrafters on 13/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

// Mark : - RecentlyView Data
class RecentlyViewed:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeImageUrl:String = ""
    var recipeUserObjectId:String = ""

    init (recipeObjectId:String, recipeTitle:String, recipeImageUrl:String, recipeUserObjectId:String)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserObjectId = recipeUserObjectId
    }
}

struct RecentlyViewedArray {
    static var recentlyViewed = [RecentlyViewed]()
}

// Mark : - BookMarkView Data
class BookMark:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeImageUrl:String = ""
    var recipeUserObjectId:String = ""

    init (recipeObjectId:String, recipeTitle:String, recipeImageUrl:String,recipeUserObjectId:String)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserObjectId = recipeUserObjectId
    }
}

struct BookMarkArray {
    static var bookMark = [BookMark]()
}

// Mark : - MyCollectionView Data
class MyCollection:NSObject {

    var recipeObjectId:String = ""
    var collectionName:String = ""

    init (recipeObjectId:String, collectionName:String)    {
        self.recipeObjectId = recipeObjectId
        self.collectionName = collectionName
    }
}

struct MyCollectionArray {
    static var collection = [MyCollection]()
}


struct BookMarkSearchArray {
    static var recentlyViewed = [RecentlyViewed]()
    static var bookmark = [BookMark]()
    static var collection = [MyCollection]()
}

struct AddCollectionArray {
    static var recipeObjectIdArray = [String]()
    static var collectionNameArray = [String]()
    static var boolCollectionArray = [Bool]()
}

struct Favourites {
    static var collectionId:String = ""
    static var collectionName:String = ""
}

class Favourite:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeImageUrl:String = ""
     var recipeBool:Bool = false

    init (recipeObjectId:String, recipeTitle:String, recipeImageUrl:String, recipeBool:Bool)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeImageUrl = recipeImageUrl
        self.recipeBool = recipeBool
    }
}

struct FavouriteArray {
    static var favourite = [Favourite]()
}

// Mark: - ViewCollection
class CollectionAllRecipe:NSObject {

    var recipeTitle:String = ""
    var recipeObjectId:String = ""
    var recipeImageUrl:String = ""
    var recipeUserObjectId:String = ""


    init (recipeTitle:String, recipeObjectId:String, recipeImageUrl:String, recipeUserObjectId:String)    {
        self.recipeTitle = recipeTitle
        self.recipeObjectId = recipeObjectId
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserObjectId = recipeUserObjectId
    }
}

struct CollectionAllRecipeArray {
    static var collectionRecipe = [CollectionAllRecipe]()
}

// Mark: - Search
class SearchBookMarkRecipe:NSObject {

    var recipeTitle:String = ""
    var recipeObjectId:String = ""
    var recipeImageUrl:String = ""
    var recipeUserObjectId:String = ""

    init (recipeTitle:String, recipeObjectId:String, recipeImageUrl:String, recipeUserObjectId:String)    {
        self.recipeTitle = recipeTitle
        self.recipeObjectId = recipeObjectId
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserObjectId = recipeUserObjectId
    }
}

struct SearchBookMark {
    static var searchRecipe = [SearchBookMarkRecipe]()
}
