//
//  BookMarkViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 07/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import EasyPopUp
import Parse
import TPKeyboardAvoiding

class BookMarkViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var bookMarkSearchTextField: SearchTextField!
    @IBOutlet weak var bookMarkScrollView: UIScrollView!
    @IBOutlet weak var bookMarkCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionCollectionView: UICollectionView!
    @IBOutlet weak var recentlyViewedCollectionView: UICollectionView!
    @IBOutlet var myCollectionPopUpView: UIView!
    @IBOutlet var myCollectionTextField: UITextField!
    @IBOutlet weak var recentlyCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookMarkcollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchCollectionView: UIView!

   // @IBOutlet weak var searchBookMarkCollectionView: UICollectionView!
    @IBOutlet weak var searchBookMarkCollectionView: TPKeyboardAvoidingCollectionView!
    @IBOutlet weak var searchBookMarkTopView: UIView!
    @IBOutlet weak var bookMarkLabelView: UIView!
     @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var clearSearchButton: UIButton!
    
    var textArray = ["New Collection", "BreakFast", "Lunch", "Dinner", "Cake"]
    var popUpConfig = EasyPopupConfig()
    var collectionName:String = ""

    var collectionNameArray = [String()]
    var collectionIdArray = [String()]
    let width = UIScreen.main.bounds.size.width
    var searchBookMarkRecipe = [SearchBookMarkRecipe]()

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!


     //Mark: - myCollectionPopUp
     lazy var myCollectionPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: myCollectionPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
         bookMarkSearchTextField.clipsToBounds = true
         recentlyViewReuseIdentifier()
         bookMarkReuseIdentifier()
         myCollectionReuseIdentifier()
         searchBookMarkReuseIdentifier()
         bookMarkSearchTextField.delegate = self
         hideKeyboardWhenTappedAround()
         keyBoardNotification()

         // Mark : - CollectionView Dynamic height and Width
         recentlyCollectionViewHeightConstraint.constant = (width - 95) / 2 + 41
         myCollectionViewHeightConstraint.constant = (width - 95) / 2 + 41
         bookMarkcollectionViewHeightConstraint.constant = (width - 95) / 2 + 41
         collectionLayout()
         LoadSpinnerView()
    }

     func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    // Mark: - Keyboard Notification
    func keyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(BookMarkViewController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BookMarkViewController.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

     // Mark: - Keyboard Show Notification
    @objc func keyboardWillShow(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                bottomConstraint.constant =  1
        }
    }

    // Mark: - Keyboard Hide Notification
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            bottomConstraint.constant = 0
        }
    }

    // Mark : - RecentlyViewed Collection Reuse Identifier
    func recentlyViewReuseIdentifier() {
         let nibName = UINib(nibName: "RecentlyViewedCollectionViewCell", bundle:nil)
        recentlyViewedCollectionView.register(nibName, forCellWithReuseIdentifier: "recentlyViewedCollectionCell")
        recentlyViewedCollectionView.delegate = self
        recentlyViewedCollectionView.dataSource = self
        recentlyViewedCollectionView.backgroundColor = .clear
    }

    // Mark : - BookMark Collection Reuse Identifier
    func bookMarkReuseIdentifier() {
        let nibName1 = UINib(nibName: "BookMarkCollectionViewCell", bundle:nil)
        bookMarkCollectionView.register(nibName1, forCellWithReuseIdentifier: "bookMarkCollectionCell")
        bookMarkCollectionView.delegate = self
        bookMarkCollectionView.dataSource = self
        bookMarkCollectionView.backgroundColor = .clear
    }

    func searchBookMarkReuseIdentifier() {
         let nibName1 = UINib(nibName: "SearchBookMarkCollectionViewCell", bundle:nil)
        searchBookMarkCollectionView.register(nibName1, forCellWithReuseIdentifier: "SearchBookMarkCollectionCell")
        searchBookMarkCollectionView.delegate = self
        searchBookMarkCollectionView.dataSource = self
        searchBookMarkCollectionView.backgroundColor = .clear
    }

      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        //spinnerView.isHidden = false
        getRecentlyViewed()
        getBookmark()
        getCollection()
       // spinnerView.isHidden = true
    }

    // Mark : - MyCollection Collection Reuse Identifier
    func myCollectionReuseIdentifier() {
        let nibName1 = UINib(nibName: "MyCollectionCollectionViewCell", bundle:nil)
        myCollectionCollectionView.register(nibName1, forCellWithReuseIdentifier: "myCollectionCollectionCell")
        myCollectionCollectionView.delegate = self
        myCollectionCollectionView.dataSource = self
        myCollectionCollectionView.backgroundColor = .clear
    }

     //Mark: - TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField == bookMarkSearchTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    @IBAction func bookMarkSerachTextField(_ sender: Any) {
        if (bookMarkSearchTextField.text?.isEmpty)! {
            //bookMarkScrollView.isHidden = false
            showBookMarkView()
        } else {
            searchBookMark()
        }
    }

    func hideBookMarkView() {
        bookMarkScrollView.isHidden = true
        bookMarkLabelView.isHidden = true
        bookMarkSearchTextField.removeIconTextField()
        bookMarkSearchTextField.leftView?.removeFromSuperview()
        bookMarkSearchTextField.clipsToBounds = true
        bookMarkSearchTextField.borderColor = UIColor._darkGray
        searchBookMarkTopView.isHidden = false
        searchCollectionView.isHidden = false
        clearSearchButton.isHidden = false
    }

    func showBookMarkView() {
        bookMarkSearchTextField.text = ""
        bookMarkScrollView.isHidden = false
        bookMarkLabelView.isHidden = false
        bookMarkSearchTextField.setupTextField()
        bookMarkSearchTextField.clipsToBounds = true
        bookMarkSearchTextField.borderColor = UIColor._darkGray
        searchBookMarkTopView.isHidden = true
        searchCollectionView.isHidden = true
        clearSearchButton.isHidden = true
    }


    @IBAction func searchBackButtonAction(_ sender: Any) {
        showBookMarkView()
    }

    @IBAction func clearSearchButtonAction(_ sender: Any) {
        showBookMarkView()
    }

    func searchBookMark() {
        //bookMarkScrollView.isHidden = true
        hideBookMarkView()
        let string = bookMarkSearchTextField.text!

            let searchRecenlyArray = RecentlyViewedArray.recentlyViewed.filter({$0.recipeTitle.lowercased().contains(string.lowercased())})
            let searchBookMarkArray = BookMarkArray.bookMark.filter({$0.recipeTitle.lowercased().contains(string.lowercased())})
            let searchCollectionAllRecipeArray = CollectionAllRecipeArray.collectionRecipe.filter({$0.recipeTitle.lowercased().contains(string.lowercased())})

        SearchBookMark.searchRecipe.removeAll()
         for (i, _) in searchRecenlyArray.enumerated() {
            print(searchRecenlyArray[i].recipeObjectId)
            SearchBookMark.searchRecipe.append(SearchBookMarkRecipe(recipeTitle: searchRecenlyArray[i].recipeTitle, recipeObjectId: searchRecenlyArray[i].recipeObjectId, recipeImageUrl: searchRecenlyArray[i].recipeImageUrl, recipeUserObjectId: searchRecenlyArray[i].recipeUserObjectId))

        }

        for (i, _) in searchBookMarkArray.enumerated() {
            SearchBookMark.searchRecipe.append(SearchBookMarkRecipe(recipeTitle: searchBookMarkArray[i].recipeTitle, recipeObjectId: searchBookMarkArray[i].recipeObjectId, recipeImageUrl: searchBookMarkArray[i].recipeImageUrl, recipeUserObjectId: searchBookMarkArray[i].recipeUserObjectId))
        }


        for (i, _) in searchCollectionAllRecipeArray.enumerated() {
            SearchBookMark.searchRecipe.append(SearchBookMarkRecipe(recipeTitle: searchCollectionAllRecipeArray[i].recipeTitle, recipeObjectId: searchCollectionAllRecipeArray[i].recipeObjectId, recipeImageUrl: searchCollectionAllRecipeArray[i].recipeImageUrl, recipeUserObjectId: searchCollectionAllRecipeArray[i].recipeUserObjectId))
        }
        searchBookMarkRecipe = SearchBookMark.searchRecipe.unique {$0.recipeObjectId }
        self.searchBookMarkCollectionView.reloadData()
    }

    // Mark : - CollectionLayout Cell Height and Width
    func collectionLayout() {
        let recentlyViewedCollectionViewlayout = self.recentlyViewedCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        recentlyViewedCollectionViewlayout.itemSize = CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 26)

         let myCollectionViewCollectionViewlayout = self.myCollectionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        myCollectionViewCollectionViewlayout.itemSize = CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 26)

         let bookMarkCollectionViewlayout = self.bookMarkCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        bookMarkCollectionViewlayout.itemSize = CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 26)

        let bookMarkSearchCollectionViewlayout = self.searchBookMarkCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        bookMarkSearchCollectionViewlayout.itemSize = CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 26)
    }

    // Mark : Get User RecentlyViewed
    func getRecentlyViewed() {
        let recentlyView = PFQuery(className:"RecentlyView")
        recentlyView.whereKey("user", equalTo: PFUser.current()!)
        recentlyView.includeKey("relationKey")
        recentlyView.includeKey("user")
        recentlyView.order(byDescending: "createdAt")
        recentlyView.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print(objects!)
                 RecentlyViewedArray.recentlyViewed.removeAll()
                 for object in objects! {
                    let recipe:PFObject = object["relationKey"] as! PFObject
                    let recipeImageFile = recipe["recipeImage"] as! PFFileObject
                    let user:PFUser = recipe["relationKey"] as! PFUser
                    RecentlyViewedArray.recentlyViewed.append(RecentlyViewed(recipeObjectId: recipe.objectId!, recipeTitle: recipe["recipeTitle"] as! String, recipeImageUrl: recipeImageFile.url!, recipeUserObjectId: user.objectId!))

                }
                self.recentlyViewedCollectionView.reloadData()
            }
        }
    }

    // Mark : Get User Collection
    func getCollection() {
        let getCollection = PFQuery(className:"Collections")
        getCollection.whereKey("user", equalTo: PFUser.current()!)
        getCollection.order(byDescending: "createdAt")
        getCollection.includeKey("user")
          getCollection.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                CollectionArray.collection.removeAll()
                CollectionArray.collection.append(Collection(collectionName: "New Collection", collectionBoolArray: false, collectionObjectId: "id", recipeImageUrl: "", recipeUserObjectId: (PFUser.current()?.objectId!)!))
                 for object in objects! {
                    self.collectionNameArray.append(object["collectionName"] as! String)
                    self.collectionIdArray.append(object.objectId!)
                    let user:PFUser = object["user"] as! PFUser
                    CollectionArray.collection.append(Collection(collectionName: object["collectionName"] as! String, collectionBoolArray: false, collectionObjectId: object.objectId!, recipeImageUrl: "", recipeUserObjectId: user.objectId!)) 
                }
                self.getCollectionRecipe()
            }
        }
    }

    // Mark : Get User Collection Recipe Image
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
                    let user:PFUser = recipe["relationKey"] as! PFUser
                    CollectionArray.collection.filter({$0.collectionObjectId == collection.objectId!}).first?.recipeImageUrl = recipeImageFile.url!
                    CollectionAllRecipeArray.collectionRecipe.append(CollectionAllRecipe(recipeTitle: recipe["recipeTitle"] as! String, recipeObjectId: recipe.objectId!, recipeImageUrl: recipeImageFile.url!, recipeUserObjectId: user.objectId!))
                }
                   self.myCollectionCollectionView.reloadData()
            }
        }
    }

    // Mark : Get User BookMarks
    func getBookmark() {
        let bookmark = PFQuery(className:"Bookmarks")
        bookmark.whereKey("user", equalTo: PFUser.current()!)
        bookmark.includeKey("relationKey")
        bookmark.includeKey("user")
        bookmark.order(byDescending: "createdAt")
        bookmark.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 BookMarkArray.bookMark.removeAll()
                 for object in objects! {
                    let recipe:PFObject = object["relationKey"] as! PFObject
                    let recipeImageFile = recipe["recipeImage"] as! PFFileObject
                    let user:PFUser = recipe["relationKey"] as! PFUser
                    BookMarkArray.bookMark.append(BookMark(recipeObjectId: recipe.objectId!, recipeTitle: recipe["recipeTitle"] as! String, recipeImageUrl: recipeImageFile.url!, recipeUserObjectId: user.objectId!))
                }
                BookMarkArray.bookMark = BookMarkArray.bookMark.removeDuplicates()
                self.bookMarkCollectionView.reloadData()
            }
        }
    }

     // Mark: - Collection submit & cancel
    @IBAction func myCollectionButtonAction(_ sender: Any) {

    }

     // Mark: - Collection Submit
     @IBAction func myCollectionSubmitAction(_ sender: Any) {
        let myCollection = self.myCollectionTextField.text!.trimmingCharacters(in: .whitespaces)
        if myCollection.isEmpty {
            print("error")
        } else {
            myCollectionPopUp.removePopup { (isfinished) in
                print(isfinished)
                if self.collectionNameArray.contains(where: {$0.caseInsensitiveCompare(myCollection) == .orderedSame}) {
                        self.alert(title: "Error", message: "Already Have a same collection name", cancel: "Dismiss")
                } else {
                    CollectionArray.collection.insert(Collection(collectionName: myCollection, collectionBoolArray:  false, collectionObjectId: "id", recipeImageUrl: "", recipeUserObjectId: (PFUser.current()?.objectId!)!), at: 1)
                     self.collectionNameArray.insert(myCollection, at: 1)
                     self.myCollectionCollectionView.reloadData()
                     self.collectionName = myCollection
                     self.myCollectionTextField.text = ""
                     self.addCollection()
                }
            }
        }
    }

    // Mark: - Create New Collection In BackEnd
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

    // Mark: - Collection Submit Cancel
     @IBAction func myCollectionCancelAction(_ sender: Any) {
        myCollectionPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }
}

extension BookMarkViewController: UICollectionViewDataSource,UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentlyViewedCollectionView {
            print(RecentlyViewedArray.recentlyViewed.count)
            return RecentlyViewedArray.recentlyViewed.count
        } else if collectionView == bookMarkCollectionView {
            return BookMarkArray.bookMark.count
        } else if collectionView == myCollectionCollectionView{
            return CollectionArray.collection.count
        } else {
            return searchBookMarkRecipe.count
        }
    }
    
    //RecentlyViewedCollectionViewCell
  //  recentlyViewedCollectionCell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width
        print((width - 95) / 2 + 36)
        return CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 36)
        //return CGSizeMake(64, 64)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        if collectionView == recentlyViewedCollectionView {
              let cell = recentlyViewedCollectionView.dequeueReusableCell(withReuseIdentifier: "recentlyViewedCollectionCell", for: indexPath as IndexPath) as! RecentlyViewedCollectionViewCell
                print(cell.frame.height)
              let loadImageParams = LoadImageParams(showActivityIndicator: false)
              cell.recentlyViewRecipeImageView.loadImage(fromUrl: RecentlyViewedArray.recentlyViewed[indexPath.item].recipeImageUrl, withParams: loadImageParams, completion: nil)
              cell.recentlyViewRecipeName.text = RecentlyViewedArray.recentlyViewed[indexPath.item].recipeTitle
              cell.backgroundColor = .clear
              return cell
        } else if collectionView == bookMarkCollectionView {
               let cell = bookMarkCollectionView.dequeueReusableCell(withReuseIdentifier: "bookMarkCollectionCell", for: indexPath as IndexPath) as! BookMarkCollectionViewCell
                print(cell.frame.height)
               let loadImageParams = LoadImageParams(showActivityIndicator: false)
              cell.bookMarkRecipeImageView.loadImage(fromUrl: BookMarkArray.bookMark[indexPath.item].recipeImageUrl, withParams: loadImageParams, completion: nil)
              cell.bookMarkRecipeTitle.text = BookMarkArray.bookMark[indexPath.item].recipeTitle
              cell.backgroundColor = .clear

              return cell
        } else if collectionView ==  myCollectionCollectionView {
             let cell = myCollectionCollectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionCollectionCell", for: indexPath as IndexPath) as! MyCollectionCollectionViewCell
                 if indexPath.item == 0 {
                    cell.recipeImageView.isHidden = true
                    cell.recipeNameLabel.text = CollectionArray.collection[indexPath.item].collectionName.firstCapitalized
                    cell.addIconImageView.isHidden = false
                } else {
                    print(cell.frame.height)
                    cell.recipeImageView.isHidden = false
                    cell.addIconImageView.isHidden = true
                    cell.recipeImageView.cornerRadius = 10
                    cell.recipeNameLabel.text = CollectionArray.collection[indexPath.item].collectionName.firstCapitalized
                    if CollectionArray.collection[indexPath.item].recipeImageUrl != "" {
                        let loadImageParams = LoadImageParams(showActivityIndicator: false)
                        cell.recipeImageView.loadImage(fromUrl: CollectionArray.collection[indexPath.item].recipeImageUrl, withParams: loadImageParams, completion: nil)
                    } else {
                        cell.recipeImageView.image = #imageLiteral(resourceName: "spash_bg")
                    }
                }
            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = searchBookMarkCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchBookMarkCollectionCell", for: indexPath as IndexPath) as! SearchBookMarkCollectionViewCell

            let loadImageParams = LoadImageParams(showActivityIndicator: false)
              cell.searchBookMarkRecipeImageView.loadImage(fromUrl: searchBookMarkRecipe[indexPath.item].recipeImageUrl, withParams: loadImageParams, completion: nil)
             cell.searchBookMarkRecipeTitle.text = searchBookMarkRecipe[indexPath.item].recipeTitle
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recentlyViewedCollectionView {
            RecipeDetail.recipeObjectId = RecentlyViewedArray.recentlyViewed[indexPath.item].recipeObjectId
            RecipeDetail.recipeUserObjectId = RecentlyViewedArray.recentlyViewed[indexPath.item].recipeUserObjectId
           navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
        } else if collectionView == bookMarkCollectionView {
             RecipeDetail.recipeObjectId = BookMarkArray.bookMark[indexPath.item].recipeObjectId
             RecipeDetail.recipeUserObjectId = BookMarkArray.bookMark[indexPath.item].recipeUserObjectId
             navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
        }  else if collectionView == myCollectionCollectionView {
            if indexPath.item == 0 {
                 myCollectionPopUp.config = popUpConfig
                    myCollectionPopUp.showPopup { (isfinished) in
                    print(isfinished)
                }
            } else {
                Favourites.collectionId = CollectionArray.collection[indexPath.item].collectionObjectId
                Favourites.collectionName = CollectionArray.collection[indexPath.item].collectionName
               self.navigationPushRedirect(storyBoardName: "BookMark", storyBoardId: "Favourites")
            }
        } else {
            RecipeDetail.recipeObjectId = searchBookMarkRecipe[indexPath.item].recipeObjectId
            RecipeDetail.recipeUserObjectId = searchBookMarkRecipe[indexPath.item].recipeUserObjectId
             navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
        }
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
