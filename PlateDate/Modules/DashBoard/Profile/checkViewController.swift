//
//  checkViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 13/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class checkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getBookmark()
        // Do any additional setup after loading the view.
    }

     @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

     // Mark : Get User BookMarks
    func getBookmark() {
        let bookmark = PFQuery(className:"Bookmarks")
        bookmark.whereKey("user", equalTo: PFUser.current()!)
        bookmark.includeKey("relationKey")
        bookmark.includeKey("user")
        bookmark.order(byDescending: "createdAt")
        bookmark.includeKey("relationKey.relationKey")
        bookmark.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 ProfileBookMarkArray.profileBookMark.removeAll()
                 for object in objects! {

                    let recipe:PFObject = object["relationKey"] as! PFObject
                     let user:PFUser = recipe["relationKey"] as! PFUser
                     print("user[userDisplayName] as? String\(user["userDisplayName"] as? String)")


                     var recipeUserImageUrl:String = ""
                        if user["profileImage"] != nil {
                            let userImageFile = user["profileImage"] as! PFFileObject
                            recipeUserImageUrl = userImageFile.url ?? ""
                            } else {
                            if user["profilePicture"] != nil {
                                recipeUserImageUrl = (user["profilePicture"] as?   String)!
                            } else {
                                recipeUserImageUrl = ""
                            }
                        }

                        print("recipeUserImageUrlrecipeUserImageUrl\(recipeUserImageUrl)")

                   // print(recipe)






                    //recipe.includeKey("relationKey")
                    let recipeImageFile = recipe["recipeImage"] as! PFFileObject
                    let recipeUser:PFUser = recipe["relationKey"] as! PFUser
                   // let user:PFUser = object["user"] as! PFUser
//                    var recipeUserImageUrl:String = ""
//                        if recipeUser["profileImage"] != nil {
//                            let userImageFile = recipeUser["profileImage"] as! PFFileObject
//                            recipeUserImageUrl = userImageFile.url ?? ""
//
//                        } else {
//                            recipeUserImageUrl = ""
//                    }

                   // ProfileBookMarkArray.profileBookMark.append(ProfileBookMark(recipeObjectId: recipe.objectId!, recipeTitle:  recipe["recipeTitle"] as! String, recipeDescription: recipe["recipeDescription"] as! String,  recipeCreateTime: String(describing: recipe.createdAt), recipeImageUrl:recipeImageFile.url ?? "", recipeUserName: user["userDisplayName"] as! String, bookMark: DashBoardArray.bookMarkString, recipeUserobjectId: recipeUser.objectId!, recipeUserImageUrl: ""))

                }
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
