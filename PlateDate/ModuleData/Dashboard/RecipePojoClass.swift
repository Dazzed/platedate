//
//  RecipePojoClass.swift
//  PlateDate
//
//  Created by DashBoardPojoClass on 06/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import Parse

class Recipe:NSObject {

    var recipeObjectId:String = ""
    var recipeTitle:String = ""
    var recipeDescription:String = ""
    var recipeCreateTime:String = ""
    var recipeImageUrl:String = ""
    var bookMark:String = ""
    var recipeUserName:String = ""
    var recipeUserobjectId:String = ""

    init (recipeObjectId:String, recipeTitle:String, recipeDescription:String, recipeCreateTime:String, recipeImageUrl:String, recipeUserName:String, bookMark:String, recipeUserobjectId:String)    {
        self.recipeObjectId = recipeObjectId
        self.recipeTitle = recipeTitle
        self.recipeDescription = recipeDescription
        self.recipeCreateTime = recipeCreateTime
        self.recipeImageUrl = recipeImageUrl
        self.recipeUserName = recipeUserName
        self.bookMark = bookMark
        self.recipeUserobjectId = recipeUserobjectId
    }
}


struct RecipeArray {
    //MARK: - Traveller
    static var recipeDisplay = [Recipe]()
}

struct RecipeDetail {
    //MARK: - Traveller
    static var recipeObjectId:String =  ""
    static var recipeImageUrl:String =  ""
    static var recipeTitle:String =  ""
    static var recipeDescription:String =  ""
    static var preparationTime:String =  ""
    static var servings:String =  ""
    static var cookWareArray = [String]()
    static var ingredientArray = [String]()
    static var preparationArray = [String]()

    static var recipeUserName:String =  ""
}
