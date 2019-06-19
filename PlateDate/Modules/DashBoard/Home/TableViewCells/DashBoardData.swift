//
//  RecipeData.swift
//  PlateDate
//
//  Created by WebCrafters on 06/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import Parse


struct RecipeArray {
    //MARK: - Recipe
    static var recipeDisplay = [Recipe]()
}

struct RecipeDetail {
    static var recipeObjectId:String = ""
    static var recipeImageUrl:String = ""
    static var recipeTitle:String = ""
    static var recipeDescription:String = ""
    static var preparationTime:String = ""
    static var servings:String = ""
    static var cookWareArray = [String]()
    static var ingredientArray = [String]()
    static var preparationArray = [String]()

    static var recipeUserName:String = ""
    static var recipeUserProfileImage:String = ""
}
