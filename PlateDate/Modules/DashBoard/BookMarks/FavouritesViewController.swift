//
//  FavouritesViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 15/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import Parse
import EasyPopUp

class FavouritesViewController: UIViewController {

    //Mark: - @IBOutlets
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    @IBOutlet weak var favouriteTopConstraint: NSLayoutConstraint!
    @IBOutlet var collectionRenamePopUpView: UIView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet var collectionRenameTextField: UITextField!
    @IBOutlet var deleteCollectionPopUpView: UIView!
    @IBOutlet var deleteRecipePopUpView: UIView!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    //Mark: - Declaration
    var removeRecipeId:String = ""
    var favoritesAnimateBool:Bool = false
    var popUpConfig = EasyPopupConfig()

    //Mark: - Rename Popup
     lazy var myCollectionPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: collectionRenamePopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    //Mark: - Delete Collection
     lazy var deleteCollectionPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: deleteCollectionPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    //Mark: - Delete Collection
     lazy var deleteRecipePopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: deleteRecipePopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesReuseIdentifier()
        collectionLayout()
        getFavouriteRecipe()
        LoadSpinnerView()
        collectionName.text = Favourites.collectionName.firstCapitalized
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinnerView.isHidden = true
    }

    func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    //Mark: - FavouriteCollectionView ReuseIdentifier
    func favouritesReuseIdentifier() {
        let nibName1 = UINib(nibName: "FavouriteCollectionViewCell", bundle:nil)
        favouriteCollectionView.register(nibName1, forCellWithReuseIdentifier: "FavouriteCell")
        favouriteCollectionView.delegate = self
        favouriteCollectionView.dataSource = self
        favouriteCollectionView.backgroundColor = .clear
    }

    //Mark: - FavouriteCollectionView CollectionLayout
    func collectionLayout() {
        let layout = self.favouriteCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
         let width = UIScreen.main.bounds.size.width
        layout.itemSize = CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 26)
    }

    //Mark: - Get User Collection Recipe
    func getFavouriteRecipe() {
        let getFavouriteRecipe = PFQuery(className:"CollectionRecipe")
        getFavouriteRecipe.whereKey("user", equalTo: PFUser.current()!)
        getFavouriteRecipe.includeKey("collectionId")
        getFavouriteRecipe.includeKey("collectionRecipeId")
        getFavouriteRecipe.includeKey("user")

        getFavouriteRecipe.order(byDescending: "createdAt")
        getFavouriteRecipe.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                FavouriteArray.favourite.removeAll()
                 for object in objects! {
                    let collection:PFObject = object["collectionId"] as! PFObject
                    let recipe:PFObject = object["collectionRecipeId"] as! PFObject
                    let recipeImageFile = recipe["recipeImage"] as! PFFileObject
                    if collection.objectId! == Favourites.collectionId {
                        FavouriteArray.favourite.append(Favourite(recipeObjectId: recipe.objectId!, recipeTitle: recipe["recipeTitle"] as! String, recipeImageUrl: recipeImageFile.url!, recipeBool: false))
                    }
                }
                self.favouriteCollectionView.reloadData()
            }
        }
    }

    //Mark: - Back Button Action
     @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    //Mark: - DropDown View Animation
    @IBAction func favouritesAnimationButtonAction(_ sender: Any) {
        if favoritesAnimateBool == false {
            favoritesAnimateBool = true
            UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.favouriteTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            favoritesAnimateBool = false
            UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.favouriteTopConstraint.constant = -50
                 self.view.layoutIfNeeded()
            })
        }
    }

    //Mark: - Collection Rename Button Action
    @IBAction func renameButtonAction(_ sender: Any) {
        myCollectionPopUp.config = popUpConfig
        self.collectionRenameTextField.text = collectionName.text!
        myCollectionPopUp.showPopup { (isfinished) in
            print(isfinished)
        }
    }

    //Mark: - User Collection PopUp Cancel Action
     @IBAction func myCollectionSubmitAction(_ sender: Any) {
        let myCollection = self.collectionRenameTextField.text!.trimmingCharacters(in: .whitespaces)
        if myCollection.isEmpty {
            print("error")
        } else {
            myCollectionPopUp.removePopup { (isfinished) in
                print(isfinished)
                Favourites.collectionName = myCollection
                self.collectionName.text = myCollection.firstCapitalized
                self.collectionRenameTextField.text = ""
                self.renameCollection()
            }
        }
    }

    //Mark: - User Collection PopUp Cancel Action
    @IBAction func myCollectionCancelAction(_ sender: Any) {
        myCollectionPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    //Mark: - Rename Collection API
    func renameCollection() {
        let renameCollection = PFQuery(className:"Collections")
        renameCollection.whereKey("user", equalTo: PFUser.current()!)
         renameCollection.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    if object.objectId! == Favourites.collectionId {
                        object["collectionName"] = Favourites.collectionName
                        object.saveInBackground()
                    }
                }
            }
        }
    }

      //Mark: - Recipe Delete Button Action
      @IBAction func deleteButtonAction(_ sender: Any) {
        deleteCollectionPopUp.config = popUpConfig
            deleteCollectionPopUp.showPopup { (isfinished) in
            print(isfinished)
        }
    }

     //Mark: - Recipe Delete PopUp Yes Button Action
    @IBAction func deleteYesButtonAction(_ sender: Any) {
        deleteCollectionRecipe()
    }

    //Mark: - Recipe Delete PopUp No Button Action
    @IBAction func deleteNoButtonAction(_ sender: Any) {
         deleteCollectionPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

     //Mark: - Delete Collection Recipe
    func deleteCollectionRecipe() {
        spinnerView.isHidden = false
        let getFavouriteRecipe = PFQuery(className:"CollectionRecipe")
        getFavouriteRecipe.whereKey("user", equalTo: PFUser.current()!)
        getFavouriteRecipe.includeKey("collectionId")
        getFavouriteRecipe.includeKey("collectionRecipeId")
        getFavouriteRecipe.includeKey("user")

        getFavouriteRecipe.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.deleteCollection()
                 self.spinnerView.isHidden = true
            } else {
                 for object in objects! {
                    let collection:PFObject = object["collectionId"] as! PFObject
                    if (collection.objectId == Favourites.collectionId) {
                         object.deleteEventually()
                    }
                }
                self.deleteCollection()
            }
        }
    }

    //Mark: - Delete Collection
    func deleteCollection() {

        let deleteCollection = PFQuery(className:"Collections")
        deleteCollection.whereKey("user", equalTo: PFUser.current()!)
         deleteCollection.whereKey("collectionName", equalTo: Favourites.collectionName)
         deleteCollection.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.spinnerView.isHidden = true
            } else {
                 for object in objects! {

                    object.deleteEventually()
                    self.spinnerView.isHidden = false
                    self.deleteCollectionPopUp.removePopup { (isfinished) in
                        print(isfinished)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    //Mark: - Delete Receipe PopUp YES
    @IBAction func deleteRecipeButtonAction(_ sender: Any) {
        removeFavourites()
    }

    //Mark: - Delete Receipe PopUp No
    @IBAction func deleteNoRecipeButtonAction(_ sender: Any) {
         deleteRecipePopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }
}

extension FavouritesViewController: UICollectionViewDataSource,UICollectionViewDelegate {

    //Mark: CollectionView Delegate and DataSource
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavouriteArray.favourite.count
    }
    

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favouriteCollectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCell", for: indexPath as IndexPath) as! FavouriteCollectionViewCell
        cell.favouriteNameLabel.text = FavouriteArray.favourite[indexPath.row].recipeTitle
        let loadImageParams = LoadImageParams(showActivityIndicator: false)
        cell.favouriteImageView.loadImage(fromUrl: FavouriteArray.favourite[indexPath.row].recipeImageUrl, withParams: loadImageParams, completion: nil)

        cell.favouriteDeleteButton.tag = indexPath.item
        cell.favouriteDeleteButton.addTarget(self, action: #selector(removeFavouritesButton), for: .touchUpInside)
        return cell
     }

     //Mark: Recipe Remove Button Action
     @objc func removeFavouritesButton(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.favouriteCollectionView)
        let indexPath = self.favouriteCollectionView.indexPathForItem(at: buttonPosition)!
        removeRecipeId = FavouriteArray.favourite[indexPath.item].recipeObjectId
        FavouriteArray.favourite.remove(at: indexPath.item)

         deleteRecipePopUp.config = popUpConfig
            deleteRecipePopUp.showPopup { (isfinished) in
            print(isfinished)
        }

    }

    //Mark: Remove Favourites Recipe
    func removeFavourites() {
         let getFavouriteRecipe = PFQuery(className:"CollectionRecipe")
        getFavouriteRecipe.whereKey("user", equalTo: PFUser.current()!)
         getFavouriteRecipe.includeKey("collectionId")
         getFavouriteRecipe.includeKey("collectionRecipeId")
         getFavouriteRecipe.includeKey("user")
         getFavouriteRecipe.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    let collection:PFObject = object["collectionId"] as! PFObject
                    let recipe:PFObject = object["collectionRecipeId"] as! PFObject
                    if collection.objectId! == Favourites.collectionId {
                        if recipe.objectId! == self.removeRecipeId {
                            object.deleteEventually()
                              self.favouriteCollectionView.reloadData()
                             self.deleteRecipePopUp.removePopup { (isfinished) in
                                print(isfinished)
                            }
                        }
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RecipeDetail.recipeObjectId = FavouriteArray.favourite[indexPath.item].recipeObjectId
            navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
    }
}



