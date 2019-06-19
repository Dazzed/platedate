//
//  AddRecipe.swift
//  PlateDate
//
//  Created by WebCrafters on 13/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

// Mark - AddRecipe Data
struct AddRecipe {
    static var recipeMode:String = "1"
    static var recipeTitle:String = ""
    static var recipeDescription:String = ""
    static var prepatationTime:String = ""
    static var servings:String = ""
    static var recipeCookWareArray = [String]()
    static var recipeIngredientArray = [String]()
    static var recipeIngredientAmountArray = [String]()
    static var recipeAddStepArray = [String]()
    static var filePath:String = ""

    static var uploadSuccessBool:Bool = false 
}

// Mark - GetRecipe Data
struct getRecipe {
    static var recipeObjectId:String = ""
    static var recipeImageLink:String = ""
    static var recipeMode:String = ""
    static var recipeTitle:String = ""
    static var recipeDescription:String = ""
    static var prepatationTime:String = ""
    static var servings:String = ""
    static var recipeCookWareArray = [String]()
    static var recipeIngredientArray = [String]()
    static var recipeIngredientAmountArray = [String]()
    static var recipeAddStepArray = [String]()
    static var filePath:String = ""
}

struct CommentRecipe {
  static var commentUserImage = UIImage()
  static var commentUserName:String = ""
  static var repliesRatingView:Double = 0.0
  static var commentImage = UIImage()
  static var comment:String = ""
  static var commentTimingLabel:String = ""
  static var commentObjectId:String = ""
  static var likeCount:String = ""
  static var imageBool:Bool = false

}


