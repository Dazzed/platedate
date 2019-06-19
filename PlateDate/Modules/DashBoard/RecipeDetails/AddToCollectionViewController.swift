//
//  AddToCollectionViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 13/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import EasyPopUp
import Parse
///searchCollectionView
class AddToCollectionViewController: UIViewController {

    //Mark: - @IBOutlets
    @IBOutlet weak var addCollectionView: UICollectionView!
    @IBOutlet var addToCollectionPopUpView: UIView!
    @IBOutlet var addToCollectionTextField: UITextField!

    //Mark: - @Declatration
    var collectionNameArray = [String()]
    var collectionIdArray = [String()]
    var collectionName:String = ""
    var collectionId:String = ""
    var popUpConfig = EasyPopupConfig()

    lazy var addToCollectionPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: addToCollectionPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionLayout()
        addCollectionReuseIdentifier()
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCollection()
    }

     //Mark: - AddCollectionView Collection Layout
    func collectionLayout() {
        let layout = self.addCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
         let width = UIScreen.main.bounds.size.width
        layout.itemSize = CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 26)
    }

     //Mark: - AddCollection Reuse Identifier
     func addCollectionReuseIdentifier() {
        let nibName1 = UINib(nibName: "AddCollectionViewCell", bundle:nil)
        addCollectionView.register(nibName1, forCellWithReuseIdentifier: "AddCollectionCell")
        addCollectionView.delegate = self
        addCollectionView.dataSource = self
        addCollectionView.backgroundColor = .clear
        addCollectionView.reloadData()
    }

    //Mark: - Get Collection
    func getCollection() {
        let getCollection = PFQuery(className:"Collections")
        getCollection.whereKey("user", equalTo: PFUser.current()!)
        getCollection.includeKey("user")
        getCollection.order(byDescending: "createdAt")
        getCollection.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                CollectionArray.collection.removeAll()
                CollectionArray.collection.append(Collection(collectionName: "New Collection", collectionBoolArray: false, collectionObjectId: "id", recipeImageUrl: "", recipeUserObjectId: PFUser.current()!.objectId!))
                 for object in objects! {
                    self.collectionNameArray.append(object["collectionName"] as! String)
                    let user:PFUser = object["user"] as! PFUser
                    self.collectionIdArray.append(object.objectId!)
                    CollectionArray.collection.append(Collection(collectionName: object["collectionName"] as! String, collectionBoolArray: false, collectionObjectId: object.objectId!, recipeImageUrl: "", recipeUserObjectId: user.objectId!))
                }
                self.getCollectionRecipe()
            }
        }
    }

    //Mark: - Get Collection Recipe
    func getCollectionRecipe() {
        let getCollectionRecipe = PFQuery(className:"CollectionRecipe")
        getCollectionRecipe.whereKey("user", equalTo: PFUser.current()!)
        getCollectionRecipe.includeKey("collectionId")
        getCollectionRecipe.includeKey("collectionRecipeId")
        getCollectionRecipe.includeKey("user")

        //getCollectionRecipe.order(byDescending: "createdAt")
        getCollectionRecipe.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                        let collection:PFObject = object["collectionId"] as! PFObject
                    let recipe:PFObject = object["collectionRecipeId"] as! PFObject
                    let recipeImageFile = recipe["recipeImage"] as! PFFileObject
                   // let user:PFUser = object["user"] as! PFUser
                    if recipe.objectId! == RecipeDetail.recipeObjectId {
                        if self.collectionIdArray.contains(collection.objectId!)   {
                             CollectionArray.collection.filter({$0.collectionObjectId == collection.objectId!}).first?.collectionBoolArray = true
                        }
                    }
                    CollectionArray.collection.filter({$0.collectionObjectId == collection.objectId!}).first?.recipeImageUrl = recipeImageFile.url!
                }
                  self.addCollectionView.reloadData()
            }
        }
    }

     //Mark: - MyCollection submit & cancel
     @IBAction func myCollectionSubmitAction(_ sender: Any) {
        let addToCollection = addToCollectionTextField.text!.trimmingCharacters(in: .whitespaces)
        if addToCollection.isEmpty {
            print("error")
        } else {
            addToCollectionPopUp.removePopup { (isfinished) in
                print(isfinished)
                if self.collectionNameArray.contains(where: {$0.caseInsensitiveCompare(addToCollection) == .orderedSame}) {
                        self.alert(title: "Error", message: "Already Have a same collection name", cancel: "Dismiss")
                } else {
                    CollectionArray.collection.insert(Collection(collectionName: addToCollection.firstCapitalized, collectionBoolArray:  false, collectionObjectId: "id", recipeImageUrl: "", recipeUserObjectId: PFUser.current()!.objectId!), at: 1)
                    self.collectionNameArray.insert(addToCollection.firstCapitalized, at: 1)
                    self.addCollectionView.reloadData()
                    self.collectionName = addToCollection
                    self.addToCollectionTextField.text = ""
                    self.addCollection()
                }
            }
        }
    }

      @IBAction func myCollectionCancelAction(_ sender: Any) {
        addToCollectionPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    //Mark: - Add Collection API
    func addCollection() {
        let addCollections = PFObject(className:"Collections")
        addCollections["user"] = PFUser.current()!
        addCollections["collectionName"] = collectionName
         addCollections.saveInBackground(block: { (success, error) in
            if error == nil {
                self.getCollection()
            }
            else {
                print(error?.localizedDescription ?? "Server Error")
        }})
    }

    //Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    //Mark: - Done Button Action
    @IBAction func doneButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension AddToCollectionViewController: UICollectionViewDataSource,UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {   
        return CollectionArray.collection.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = addCollectionView.dequeueReusableCell(withReuseIdentifier: "AddCollectionCell", for: indexPath as IndexPath) as! AddCollectionViewCell
          if indexPath.item == 0 {
               cell.addCollectionImageView.isHidden = true
               cell.addIconImageView.isHidden = false
               cell.shadowView.isHidden = true
               cell.addCollectionName.text = CollectionArray.collection[indexPath.item].collectionName
            } else {
                cell.addCollectionImageView.isHidden = false
                cell.shadowView.isHidden = false
                cell.addCollectionName.text = CollectionArray.collection[indexPath.item].collectionName.firstCapitalized
                if CollectionArray.collection[indexPath.item].recipeImageUrl != "" {
                    let loadImageParams = LoadImageParams(showActivityIndicator: false)
                    cell.addCollectionImageView.loadImage(fromUrl: CollectionArray.collection[indexPath.item].recipeImageUrl, withParams: loadImageParams, completion: nil)
                } else {
                    cell.addCollectionImageView.image = #imageLiteral(resourceName: "spash_bg")
                }
            }

            if CollectionArray.collection[indexPath.item].collectionBoolArray == true {
                  cell.addIconImageView.image = #imageLiteral(resourceName: "orange_check")
            } else {
                 cell.addIconImageView.image = #imageLiteral(resourceName: "Add Icon")
            }

          cell.backgroundColor = .clear
          return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
             addToCollectionPopUp.config = popUpConfig
                addToCollectionPopUp.showPopup { (isfinished) in
                print(isfinished)
            }
        } else {
            collectionName = CollectionArray.collection[indexPath.item].collectionName
            collectionId = CollectionArray.collection[indexPath.item].collectionObjectId
            if CollectionArray.collection[indexPath.item].collectionBoolArray == true {
                CollectionArray.collection[indexPath.item].collectionBoolArray = false
                removeCollectionRecipe()
            } else {
                CollectionArray.collection[indexPath.item].collectionBoolArray = true
                CollectionArray.collection[indexPath.item].recipeImageUrl = RecipeDetail.recipeImageUrl
                addCollectionRecipe()
            }
            addCollectionView.reloadData()
        }
    }

    //Mark: - Add Collection Recipe
    func addCollectionRecipe() {
        let addCollectionRecipe = PFObject(className:"CollectionRecipe")
        let addCollections = PFObject(className:"Collections")

        addCollectionRecipe["collectionId"] = addCollections
        addCollectionRecipe["collectionId"] = PFObject(withoutDataWithClassName:"Collections",  objectId:(collectionId))

        let recipe = PFObject(className:"Recipe")
        addCollectionRecipe["collectionRecipeId"] = recipe
        addCollectionRecipe["collectionRecipeId"] = PFObject(withoutDataWithClassName:"Recipe",  objectId: RecipeDetail.recipeObjectId)

        let user = PFUser.current()
        addCollectionRecipe["user"] = user

        addCollectionRecipe.saveInBackground(block: { (success, error) in
            if error == nil {
                print("success")
            }
            else {
                print(error?.localizedDescription ?? "Server Error")
        }})
    }

    //Mark: - Remove Collection Recipe
    func removeCollectionRecipe() {
        let removeCollectionRecipe = PFQuery(className:"CollectionRecipe")
        removeCollectionRecipe.whereKey("user", equalTo: PFUser.current()!)
         removeCollectionRecipe.includeKey("collectionId")
         removeCollectionRecipe.includeKey("collectionRecipeId")
         removeCollectionRecipe.includeKey("user")

         removeCollectionRecipe.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    let collection:PFObject = object["collectionId"] as! PFObject
                    let recipe:PFObject = object["collectionRecipeId"] as! PFObject
                    if collection.objectId! == self.collectionId &&  recipe.objectId! == RecipeDetail.recipeObjectId {
                        object.deleteEventually()
                        self.getCollection()
                    }
                }
            }
        }
    }
}
