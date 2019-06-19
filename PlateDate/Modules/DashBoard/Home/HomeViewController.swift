//
//  HomeViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Parse
import EasyPopUp
//import TPKeyboardAvoiding

class HomeViewController: UIViewController, UISearchControllerDelegate {

    //@IBOutlet var topView: UIView!
    @IBOutlet var recipeSearchTextField: SearchTextField!
    @IBOutlet var segmentTitle: ScrollableSegmentedControl!
    @IBOutlet var trendingTableView: UITableView!
    @IBOutlet var followingTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var searchSegmentTitle: ScrollableSegmentedControl!
    @IBOutlet weak var searchResultTopView: UIView!
    @IBOutlet weak var searchResultTagView: UIView!
    @IBOutlet weak var recipeTagView: UIView!
    @IBOutlet weak var cooksTagView: UIView!
    @IBOutlet weak var ingredientTagView: TagListView!
    @IBOutlet weak var recentTagView: TagListView!
    @IBOutlet weak var popularTagView: TagListView!
    @IBOutlet weak var searchResultDropDownView: UIView!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var searchCollectionView: UICollectionView!

    @IBOutlet weak var popularTageViewHeightConstrint: NSLayoutConstraint!
    @IBOutlet weak var ingredientTagViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentTagViewHeightConstraint: NSLayoutConstraint!

    var searchDisplayString  = ""
    var recentSearchIngredientArray = [String]()
    var addIngredientArray = [String]()

    // @IBOutlet weak var shadowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plateDateLabelTopConstrint: NSLayoutConstraint!

    // Mark: - Declaration
    let screenSize = UIScreen.main.bounds
    var titleArray = [String]()
    var descriptionArray = [String]()
    var timeArray = [String]()
    var profileImageArray = [String]()
    var recipeImageArray = [String]()
    var userNameArray = [String]()
    var popUpConfig = EasyPopupConfig()
    var trendingShadowHeight:CGFloat = 0
    var followingShadowheight:CGFloat = 0
    var lastContentOffset: CGFloat = 0
    @IBOutlet var userLoginPopUpView: UIView!
    @IBOutlet var addIngredientPopUpView: UIView!
    @IBOutlet weak var addIngredientTextField: UITextField!
    var otherUserIndex:Int = 0
    var searchStringArray = [String]()
    var paginationCount:Int = 0
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!
    @IBOutlet weak var recipesNullView: UIView!
    @IBOutlet weak var recipeNullLabel: UILabel!
    @IBOutlet weak var recipeCancelButtonAction: UIButton!


    var cellHeightsDictionary: [AnyHashable : Any]!


    // Mark: - User Login PopUp
     lazy var userLoginPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: userLoginPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

     // Mark: - User Login PopUp
     lazy var addIngredientPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: addIngredientPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    // MARK: - Email Button Action
    @IBAction func emailButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.emailLoginStoryBoardId)
    }

    @IBAction func phoneButtonAction(_ sender: Any) {
       navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.authentication, storyBoardId: ViewController.StoryBoardId.mobileLoginStoryBoardId)
    }

    @IBAction func faceBookButtonAction(_ sender: AnyObject) {
        facebook()
    }

    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        userLoginPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    lazy var viewControllerPopup : EasyViewControllerPopup = {
        let secondViewController = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "UserLogin")
        //self.navigationController?.pushViewController(secondViewController, animated: true)
        let easePopUp = EasyViewControllerPopup(sourceViewController: self, destinationViewController:  secondViewController )
            popUpConfig.animationType = .scale
        popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        cellHeightsDictionary = [:]
        LoadSpinnerView()
        trendingReuseIdentifier()
        followingReuseIdentifier()
        addCollectionReuseIdentifier()
        setUpSegment()
        dropDownIdentifier()
        searchSetUpSegment()
        hideKeyboardWhenTappedAround()
        //swipeTableView()
        if PFUser.current()?.objectId != nil {
            retriveUserImage()
            displayRecentTagView()
        }

        if PFUser.current()?.objectId != nil {
            getBookmark()
        } else {
            recentTagViewHeightConstraint.constant = 1
            self.displayRecipes()
        }

        self.tabBarController?.tabBar.isHidden = true


       refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(sender:)), for: UIControlEvents.valueChanged)

       trendingTableView.addSubview(refreshControl)
       collectionLayout()
       displayIngrdientTagView()
       displayPopularTagView()
    }

    func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    //Mark: - AddCollectionView Collection Layout
    func collectionLayout() {
        let layout = self.searchCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
         let width = UIScreen.main.bounds.size.width
        layout.itemSize = CGSize(width:(width - 95) / 2 , height:(width - 95) / 2 + 26)
    }

     //Mark: - AddCollection Reuse Identifier
     func addCollectionReuseIdentifier() {
        let nibName1 = UINib(nibName: "SearchRecipeCollectionViewCell", bundle:nil)
        searchCollectionView.register(nibName1, forCellWithReuseIdentifier: "SearchRecipeCollectionCell")
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .clear
        searchCollectionView.reloadData()
    }

    @IBAction func editingDidBegin(_ sender: Any) {
       // searchResultDropDownView.isHidden = false
        searchResultTopView.isHidden = false
        searchResultTagView.isHidden = false
    }

    @IBAction func textFieldButtonAction(_ sender: Any) {
        searchResultTopView.isHidden = false
        searchResultTagView.isHidden = false
        recipeCancelButtonAction.isHidden = true
        searchResultDropDownView.isHidden = true
        recipeSearchTextField.text = ""
    }


    @IBAction func searchtextTieldEditingChanged(_ sender: Any) {
        if recipeSearchTextField.text?.count == 0 {
            print("textField\("textField00000")")
            searchResultDropDownView.isHidden = true
            recipeCancelButtonAction.isHidden = true
        } else {
            searchResultDropDownView.isHidden = false
            dropDownTableView.isHidden = false
            searchCollectionView.isHidden = true
            recipeCancelButtonAction.isHidden = false
            recipesNullView.isHidden = true
            searchRecipe()
        }
    }

    @IBAction func searchBackButtonAction(_ sender: Any) {
        searchResultTopView.isHidden = true
        searchResultTagView.isHidden = true
        searchResultDropDownView.isHidden = true
        recipeSearchTextField.text = ""
    }

    func searchRecipe() {
        let recipeTitleQuery = PFQuery(className: "Recipe")
        recipeTitleQuery.whereKey("recipeTitle", matchesRegex: self.recipeSearchTextField.text!, modifiers: "i")

        let recipeIngredientQuery = PFQuery(className: "Recipe")
        recipeTitleQuery.whereKey("recipeIngredient", matchesRegex: self.recipeSearchTextField.text!, modifiers: "i")
        let query = PFQuery.orQuery(withSubqueries: [recipeTitleQuery, recipeIngredientQuery])

        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
        if let error = error {
            // The request failed
            print("error")
            print(error.localizedDescription)
        } else if let objects = objects {
            self.searchStringArray.removeAll()

            objects.forEach { (object) in
                if object["recipeMode"] as? String == "0" {
                    if object["recipeTitle"] != nil {
                        if ((object["recipeTitle"] as? String)?.containsIgnoringCase(find: self.recipeSearchTextField.text!))! {
                            self.searchStringArray.append(object["recipeTitle"] as! String)
                        }
                    }
                    if object["recipeIngredient"] != nil {
                        var array = [String]()
                        array = object["recipeIngredient"] as! [String]
                        for (i,_) in array.enumerated() {
                            if array[i].containsIgnoringCase(find: self.recipeSearchTextField.text!) {
                                self.searchStringArray.append(array[i])
                            }
                        }
                    }
                  }
                }
            self.searchStringArray = self.searchStringArray.removeDuplicates()
            self.dropDownTableView.reloadData()
            }
        }
    }


     func searchRecipe1() {
        let query = PFQuery(className: "Recipe")
        query.whereKey("recipeTitle", matchesText: self.recipeSearchTextField.text!)
        query.selectKeys(["$recipeTitle"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
        if let error = error {
            // The request failed
            print("error")
            print(error.localizedDescription)
        } else if let objects = objects {
            objects.forEach { (object) in
                print("workinf\(object["recipeTitle"] ?? "")")
                print("workinf\(object["recipeIngredient"] ?? "")")

                }
            }
        }
    }


    //Mark: - TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == recipeSearchTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                  searchResultDropDownView.isHidden = true
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
           } else {
                if(textField.text?.count == 0) {
                    print("textField\("textField00000")")
                    searchResultDropDownView.isHidden = true
                }
            }
        }

        if textField == addIngredientTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
           }
        }
            return true
    }

    @objc func refresh(sender:AnyObject) {
         if PFUser.current()?.objectId != nil {
            getBookmark()
        } else {
            self.displayRecipes()
        }

        self.refreshControl.endRefreshing()
    }


    func retriveUserImage() {
        let user = PFUser.current()!

        var recipeUserImageUrl:String = ""
        if user["profileImage"] != nil {
            let userImageFile = user["profileImage"] as! PFFileObject
            recipeUserImageUrl = userImageFile.url ?? ""
        } else {
            if user["profilePicture"] != nil {
                recipeUserImageUrl = (user["profilePicture"] as? String)!
            } else {
                recipeUserImageUrl = ""
            }
        }

        User.userProfileImageUrl = recipeUserImageUrl

        if recipeUserImageUrl != "" {
            let url = URL(string: recipeUserImageUrl)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            User.userProfileImage = UIImage(data: data!)
        }
    }



    func ingredientTagAddView() {

    }
    // Mark: - Swipe Direction
    func swipeTableView() { 
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
         swipeLeft.direction = UISwipeGestureRecognizerDirection.left
         self.view.addGestureRecognizer(swipeLeft)
    }

    // Mark: - Swipe Gesture Action
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
               // trendingAnimation()
                segmentTitle.selectedSegmentIndex = 0
            case UISwipeGestureRecognizerDirection.left:
                //followingAnimation()
                segmentTitle.selectedSegmentIndex = 1
            default:
                print("sdsd")
            }
        }
    }

    //Mark: Get Scrolling Y Position
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    //Mark: Find Scroll UP or Down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
              //  self.plateDateLabelTopConstrint.constant = -90
                if self.segmentTitle.selectedSegmentIndex == 0 {
                   // self.trendingAnimation()
                } else {
                   // self.followingAnimation()
                }
                self.view.layoutIfNeeded()

               // self.searchView.isHidden = true
            })
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                if self.segmentTitle.selectedSegmentIndex == 0 {
                   // self.trendingAnimation()
                } else {
                   // self.followingAnimation()
                }
                //self.plateDateLabelTopConstrint.constant = 0
                self.view.layoutIfNeeded()
             })
        } else {
            // didn't move
        }

//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
////
//        if offsetY > contentHeight - scrollView.frame.size.height {
//            paginationCount = paginationCount + 1
//            if PFUser.current()?.objectId != nil {
//                getBookmark()
//            } else {
//                self.displayRecipes()
//            }
//            self.trendingTableView.reloadData()
//        }
    }

//    func constraintsShow() {
//        self.searchViewHeightConstarint.constant = 107
//        self.searchTextFieldTopConstraint.constant  = 10
//        self.searchTextFieldHeightConstraint.constant = 40
//        self.segmentTopConstraint.constant = 15
//        self.segmentHeightConstraint.constant = 43
//    }

//    func constraintsHide() {
//        self.searchViewHeightConstarint.constant = 0
//        self.searchTextFieldTopConstraint.constant = 0
//        self.searchTextFieldHeightConstraint.constant = 0
//        self.segmentTopConstraint.constant = 0
//        self.segmentHeightConstraint.constant = 0
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        shadowImageView.addTopBorderWithColor(color: UIColor._bottomBorderGray, width: 1.0, view: shadowImageView)
        //view.bringSubview(toFront: segmentTitle)
        hideNavigationBar()
        recipeSearchTextField.clipsToBounds = true

        self.tabBarController?.tabBar.isHidden = false
        // trendingTableView.reloadData()

        if DashBoard.bookMarkIndex != nil {
            reload()
        }
        //displayRecipes()
    }

    func reload() {
        let indexPath = NSIndexPath(row: DashBoard.bookMarkIndex, section: 0)
        trendingTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)

    }

     // Mark: - Get BookMark
    func getBookmark() {
        let bookmark = PFQuery(className:"Bookmarks")
        bookmark.whereKey("user", equalTo: PFUser.current()!)
        bookmark.includeKey("relationKey")
        bookmark.order(byDescending: "createdAt")
        bookmark.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.displayRecipes()
            } else {
                 DashBoardArray.bookMark.removeAll()
                 for object in objects! {
                    let recipe:PFObject = object["relationKey"] as! PFObject
                    DashBoardArray.bookMark.append(recipe.objectId!)
                }
            }
            self.displayRecipes()
        }
    }

    // Mark: - Display All Recipe
    func displayRecipes() {
        let query = PFQuery(className:"Recipe")
        query.includeKey("relationKey")
       // query.limit = 20
       // query.skip = paginationCount * 20
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground(block: { (recipes: [PFObject]?, error: Error?) in
            if let error = error {
                // There was an error
                print(error.localizedDescription)
            } else {
                if self.paginationCount == 0 {
                    RecipeArray.recipeDisplay.removeAll()
                }
                for recipe in recipes! {
                    let user:PFUser = recipe["relationKey"] as! PFUser
                    if recipe["recipeMode"] as! String == "0" {
                        if DashBoardArray.bookMark.contains(recipe.objectId!) {
                            DashBoardArray.bookMarkString = "1"
                        } else {
                             DashBoardArray.bookMarkString = "0"
                        }

                        var recipeUserImageUrl:String = ""

                        if user["profileImage"] != nil {
                            let userImageFile = user["profileImage"] as! PFFileObject
                            recipeUserImageUrl = userImageFile.url ?? ""
                            } else {
                            if user["profilePicture"] != nil {
                                recipeUserImageUrl = (user["profilePicture"] as? String)!
                            } else {
                                recipeUserImageUrl = ""
                            }
                        }

                        let recipeImageFile = recipe["recipeImage"] as! PFFileObject
                        RecipeArray.recipeDisplay.append(Recipe(recipeObjectId: recipe.objectId!, recipeTitle:  recipe["recipeTitle"] as! String, recipeDescription: recipe["recipeDescription"] as! String, recipeCreateTime: String(describing: recipe.createdAt?.toLocalTime()), recipeImageUrl: recipeImageFile.url!, recipeUserName: user["userDisplayName"] as! String, bookMark: DashBoardArray.bookMarkString, recipeUserobjectId: user.objectId!, recipeUserImageUrl : recipeUserImageUrl, user: user))
                    }
                }
                self.trendingTableView.reloadData()
            }
        })
    }

     // Mark: - Retrive User Data
    func retriveUserValues() {
       let  query = PFUser.query()
        query?.whereKey("objectId", equalTo: PFUser.current()?.objectId ?? "")
        query?.findObjectsInBackground { (objects, error) in
            if let error = error {
                //The query returned an error
                print(error.localizedDescription)
            } else {
                for object in objects! {
                    print(object["profileName"])
                }
            }
        }
    }

    // Mark: - SetUp Segment
    func setUpSegment() {
        segmentTitle.segmentStyle = .textOnly
        segmentTitle.insertSegment(withTitle: "Trending", image: nil, at: 0)
        //segmentTitle.insertSegment(withTitle: "Following", image: nil, at: 1)
        segmentTitle.underlineSelected = true
        segmentTitle.selectedSegmentIndex = 0
        segmentTitle.fixedSegmentWidth = true
        segmentTitle.tintColor = UIColor.clear
        segmentTitle.addTarget(self, action: #selector(HomeViewController.segmentSelected(sender:)), for: .valueChanged)
    }

    // Mark: - Search SetUp Segment
    func searchSetUpSegment() {
        searchSegmentTitle.segmentStyle = .textOnly
        searchSegmentTitle.insertSegment(withTitle: "Recipes", image: nil, at: 0)
       // searchSegmentTitle.insertSegment(withTitle: "Cooks", image: nil, at: 1)
        searchSegmentTitle.underlineSelected = true
        searchSegmentTitle.selectedSegmentIndex = 0
        searchSegmentTitle.fixedSegmentWidth = true
        searchSegmentTitle.tintColor = UIColor.clear
        searchSegmentTitle.addTarget(self, action: #selector(HomeViewController.searchSegmentSelected(sender:)), for: .valueChanged)
    }


     // Mark: - Segment Selected
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //trendingAnimation()
        } else {
          //  followingAnimation()
        }
    }

     // Mark: - Segment Selected
    @objc func searchSegmentSelected(sender:ScrollableSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //recipeAnimation()
        } else {
            //cookAnimation()
        }
    }

    func trendingAnimation() {
         UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.trendingTableView.frame = CGRect(x:0 , y:self.trendingTableView.frame.origin.y, width:self.trendingTableView.frame.width, height:self.trendingTableView.frame.height)
            self.followingTableView.frame = CGRect(x: self.screenSize.width , y:self.followingTableView.frame.origin.y, width:self.followingTableView.frame.width, height:self.followingTableView.frame.height)
        })
    }

    func followingAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.trendingTableView.frame = CGRect(x: -self.screenSize.width , y:self.trendingTableView.frame.origin.y, width:self.trendingTableView.frame.width, height:self.trendingTableView.frame.height)
            self.followingTableView.frame = CGRect(x:0 , y:self.followingTableView.frame.origin.y, width:self.followingTableView.frame.width, height:self.followingTableView.frame.height)
        })
    }

    func recipeAnimation() {
         UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.recipeTagView.frame = CGRect(x:0 , y:self.recipeTagView.frame.origin.y, width:self.recipeTagView.frame.width, height:self.recipeTagView.frame.height)
            self.cooksTagView.frame = CGRect(x: self.screenSize.width , y:self.cooksTagView.frame.origin.y, width:self.cooksTagView.frame.width, height:self.cooksTagView.frame.height)
        })
    }

    
    func cookAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.recipeTagView.frame = CGRect(x: -self.screenSize.width , y:self.recipeTagView.frame.origin.y, width:self.recipeTagView.frame.width, height:self.recipeTagView.frame.height)
            self.cooksTagView.frame = CGRect(x:0 , y:self.cooksTagView.frame.origin.y, width:self.cooksTagView.frame.width, height:self.cooksTagView.frame.height)
        })
    }

    // Mark: - Trending
    func trendingReuseIdentifier() {
        trendingTableView.delegate = self
        trendingTableView.register(UINib(nibName: TableViewCell.ClassName.trending, bundle: nil), forCellReuseIdentifier: TableViewCell.ReuseIdentifier.trending)
        trendingTableView.separatorStyle = .none
        trendingTableView.backgroundColor = .clear
        trendingTableView.rowHeight = UITableViewAutomaticDimension
        trendingTableView.contentInset.bottom = 23
    }

    // Mark: - Following
    func followingReuseIdentifier() {
        followingTableView.delegate = self
        followingTableView.dataSource = self
        followingTableView.register(UINib(nibName: TableViewCell.ClassName.following, bundle: nil), forCellReuseIdentifier: TableViewCell.ReuseIdentifier.following)
        followingTableView.separatorStyle = .none
        followingTableView.reloadData()
        followingTableView.backgroundColor = .clear
        followingTableView.contentInset.bottom = 23
    }

    // Mark: - Trending
    func dropDownIdentifier() {
        dropDownTableView.delegate = self
        dropDownTableView.register(UINib(nibName: "DropDownTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.separatorStyle = .none
        dropDownTableView.backgroundColor = .clear
        dropDownTableView.contentInset.bottom = 23
    }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            showNavigationBar()
        }

    func segmentButton() {
        trendingTableView.frame = CGRect(x:0, y:trendingTableView.frame.origin.y, width:trendingTableView.frame.width, height:trendingTableView.frame.height)
    }

    func displayIngrdientTagView() {
        ingredientTagView.textFont = UIFont(name: "SourceSansPro-Semibold", size: 14)!
        ingredientTagView.delegate = self
        ingredientTagViewHeightConstraint.constant = ingredientTagView.intrinsicContentSize.height
        print(ingredientTagView.intrinsicContentSize.height)
    }


    func displayRecentTagView() {
        recentTagView.delegate = self
        recentTagView.textFont = UIFont(name: "SourceSansPro-Semibold", size: 14)!
        let user = PFUser.current()!
        if user["recentSearchIngredient"] != nil {
            recentSearchIngredientArray = user["recentSearchIngredient"] as! [String]
            recentSearchIngredientArray = recentSearchIngredientArray.removeDuplicates()
            recentTagView.addTags(recentSearchIngredientArray)
        }

        if user["userAddIngredient"] != nil {
            addIngredientArray = user["userAddIngredient"] as! [String]
            ingredientTagView.addTags(addIngredientArray)
        }

        ingredientTagViewHeightConstraint.constant = ingredientTagView.intrinsicContentSize.height
        recentTagViewHeightConstraint.constant = recentTagView.intrinsicContentSize.height
    }

    func displayPopularTagView() {
        popularTagView.textFont = UIFont(name: "SourceSansPro-Semibold", size: 14)!
        popularTagView.delegate = self
        popularTagView.addTag("Cheese")
        popularTagView.addTag("black tea")
        popularTagView.addTag("milk")
        popularTagView.addTag("bay leaves")
        popularTagView.addTag("tomato")
        popularTageViewHeightConstrint.constant = popularTagView.intrinsicContentSize.height
    }

    @IBAction func addIngrdientPopUpAction(_ sender: Any) {
        if PFUser.current()?.objectId == nil {
            userLoginPopUp.config = popUpConfig
            userLoginPopUp.showPopup { (isfinished) in
                print(isfinished)
            }
        } else {
            addIngredientPopUp.config = popUpConfig
            addIngredientPopUp.showPopup { (isfinished) in
                print(isfinished)
            }
        }
    }


    @IBAction func addIngredientSubmitButtonAction(_ sender: Any) {
        if addIngredientTextField.text != "" {
            ingredientTagView.addTag(addIngredientTextField.text!)
            addIngredientArray.append(addIngredientTextField.text!)
            addIngredientPopUp.removePopup { (isfinished) in
                print(isfinished)
                self.addIngredientTextField.text = ""
                self.ingredientTagViewHeightConstraint.constant = self.ingredientTagView.intrinsicContentSize.height
            }
             if PFUser.current()?.objectId != nil {
                let user = PFUser.current()!
                user["userAddIngredient"] = addIngredientArray
                user.saveEventually()
            } else {
                userLoginPopUp.config = popUpConfig
                userLoginPopUp.showPopup { (isfinished) in
                    print(isfinished)
                }
            }
        }
    }

    @IBAction func ingredientCancelButtonAction(_ sender: Any) {
        addIngredientPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }


    func addIngredientCancelButtonAction(_ sender: AnyObject) {
        ingredientTagViewHeightConstraint.constant = recentTagView.intrinsicContentSize.height
        addIngredientPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

      //Mark: - Facebook Button Action
    func facebook() {
        let permissions = ["public_profile", "email"]
     PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user: PFUser?, error: Error?) in
            if let user = user {
                if user.isNew {
                    User.firstLogin = true
                    self.getData()
                } else {
                    User.firstLogin = false
                    self.login()
                }
            } else {
                print("Uh oh. The user cancelled the    Facebook login.")
            }
        }
    }

    func getData() {
        // Create request for user's Facebook data
        let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
            // Send request to Facebook
        request?.start { (connection, result, error) in
            if error != nil {
                // Some error checking here
            } else if let userData = result as? [String:AnyObject] {
                let id = userData["id"] as? String
                let profilePicUrl = "https://graph.facebook.com/\(id!)/picture"
                let user = PFUser.current()
                user!["profilePicture"] = profilePicUrl
                user?.saveInBackground(block: { (success, error) in
                    if (success) {
                        User.id = (PFUser.current()?.objectId)!
                        self.login()
                    } else {
                        print(error ?? "Server error")
                    }
                })
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate, TagListViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == trendingTableView {
            return RecipeArray.recipeDisplay.count
        } else {
            return self.searchStringArray.count
        }
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == trendingTableView {
            //trendingShadowHeight = UITableViewAutomaticDimension
            return UITableViewAutomaticDimension
        } else {
            followingShadowheight = tableViewHeight(tableView:followingTableView, height: 585.0) * 5
            return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == trendingTableView {
            let cell = trendingTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.trending) as! TrendingRecipiesTableViewCell

            cell.recipeTitleLabel.text = RecipeArray.recipeDisplay[indexPath.row].recipeTitle
            cell.recipeDescriptionLabel.text = RecipeArray.recipeDisplay[indexPath.row].recipeDescription
            cell.recipeUserNameLabel.text = RecipeArray.recipeDisplay[indexPath.row].recipeUserName
            cell.recipeTimeLabel.text = currentTime(time: RecipeArray.recipeDisplay[indexPath.row].recipeCreateTime).uppercased()


            //let loadImageParams = LoadImageParams(showActivityIndicator: false, forceRefresh: false, resizeBeforeCaching: true)
           // let loadImageParams = LoadImageParams(showActivityIndicator: false, forceRefresh: false, resizeBeforeCaching: true)
           let loadImageParams = LoadImageParams()

            //let loadImageParams = LoadImageParams(backgroundColor: false, placeholder: false, placeholderContentMode: false)
            cell.trendingRecipeImageView.loadImage(fromUrl: RecipeArray.recipeDisplay[indexPath.row].recipeImageUrl, withParams: loadImageParams, completion: nil)
        print("RecipeArray.recipeDisplay[indexPath.row].recipeUserImageUrl\(RecipeArray.recipeDisplay[indexPath.row].recipeUserImageUrl)")

            if RecipeArray.recipeDisplay[indexPath.row].recipeUserImageUrl != "" {
                cell.recipeUserImageView.loadImage(fromUrl: RecipeArray.recipeDisplay[indexPath.row].recipeUserImageUrl, withParams: loadImageParams, completion: nil)
            } else {
                cell.recipeUserImageView.image = #imageLiteral(resourceName: "Profile")
            }

            cell.recipeUserButton.tag = indexPath.row
            cell.recipeUserButton.addTarget(self, action: #selector(otherUserProfile), for: .touchUpInside)

            cell.recipeBookMarkButton.tag = indexPath.row
            if PFUser.current()?.objectId == nil {
                cell.recipeBookMarkButton.addTarget(self, action: #selector(loginPopUpAction), for: .touchUpInside)
            } else {
                 cell.recipeBookMarkButton.addTarget(self, action: #selector(bookMarkButtonAction), for: .touchUpInside)
            }

            if RecipeArray.recipeDisplay[indexPath.row].bookMark == "1" {
                cell.recipeBookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark orange.png"), for: .normal)
            } else {
                 cell.recipeBookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark grey.png"), for: .normal)
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
           // trendingShadowHeight = cell.frame.height * CGFloat(RecipeArray.recipeDisplay.count) + 23
           // shadowViewHeightConstraint.constant = trendingShadowHeight

            return cell
        }
        else {
            let cell = dropDownTableView.dequeueReusableCell(withIdentifier:  "DropDownCell") as! DropDownTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.dropDownLabel.text = searchStringArray[indexPath.row]
            return cell
        }
    }

    @objc func otherUserProfile(sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: trendingTableView)
        let indexPath = trendingTableView.indexPathForRow(at: buttonPosition)!
        Profile.user = "otherUser"
        OtherUserProfile.user = RecipeArray.recipeDisplay[indexPath.row].user
        navigationPushRedirect(storyBoardName: "Profile", storyBoardId: "OtherUser")
    }

        //Mark: - BookMark buttonAction
     @objc func bookMarkButtonAction(sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: trendingTableView)
        let indexPath = trendingTableView.indexPathForRow(at: buttonPosition)!
        let cell = trendingTableView.cellForRow(at: indexPath) as! TrendingRecipiesTableViewCell
        if RecipeArray.recipeDisplay[indexPath.row].bookMark == "1" {
            RecipeArray.recipeDisplay[indexPath.row].bookMark = "0"
            cell.recipeBookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark grey.png"), for: .normal)
            DashBoardArray.removeBookMark = RecipeArray.recipeDisplay[indexPath.row].recipeObjectId
            removeBookMark()
        } else {
            RecipeArray.recipeDisplay[indexPath.row].bookMark = "1"
            cell.recipeBookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark orange.png"), for: .normal)
            DashBoardArray.removeBookMark = RecipeArray.recipeDisplay[indexPath.row].recipeObjectId
            AddProfileBookMark.recipeObjectId = RecipeArray.recipeDisplay[indexPath.row].recipeObjectId
            AddProfileBookMark.recipeTitle = RecipeArray.recipeDisplay[indexPath.row].recipeTitle
            AddProfileBookMark.recipeDescription = RecipeArray.recipeDisplay[indexPath.row].recipeDescription
            AddProfileBookMark.recipeCreateTime = RecipeArray.recipeDisplay[indexPath.row].recipeCreateTime
            AddProfileBookMark.recipeImageUrl = RecipeArray.recipeDisplay[indexPath.row].recipeImageUrl
            AddProfileBookMark.bookMark = RecipeArray.recipeDisplay[indexPath.row].bookMark
            AddProfileBookMark.recipeUserName = RecipeArray.recipeDisplay[indexPath.row].recipeUserName
            AddProfileBookMark.recipeUserobjectId = RecipeArray.recipeDisplay[indexPath.row].recipeUserobjectId
            AddProfileBookMark.recipeUserobjectId = RecipeArray.recipeDisplay[indexPath.row].recipeUserImageUrl
            addBookmark()
        }

     }

    @objc func loginPopUpAction(sender: Any) {
         userLoginPopUp.config = popUpConfig
         userLoginPopUp.showPopup { (isfinished) in
            print(isfinished)
        }
    }

    //Mark: - Add BookMark API
     func addBookmark() {
        let bookmarks = PFObject(className:"Bookmarks")
        let recipe = PFObject(className:"Recipe")
        let user = PFUser.current()

        bookmarks["relationKey"] = recipe
        bookmarks["user"] = user
        bookmarks["relationKey"] = PFObject(withoutDataWithClassName:"Recipe",  objectId:(DashBoardArray.removeBookMark))
         bookmarks.saveInBackground(block: { (success, error) in
            if error == nil {

                ProfileBookMarkArray.profileBookMark.insert((ProfileBookMark(recipeObjectId: AddProfileBookMark.recipeObjectId, recipeTitle:  AddProfileBookMark.recipeTitle, recipeDescription: AddProfileBookMark.recipeDescription,  recipeCreateTime: AddProfileBookMark.recipeCreateTime, recipeImageUrl:AddProfileBookMark.recipeImageUrl, recipeUserName: AddProfileBookMark.recipeUserName, bookMark: AddProfileBookMark.bookMark, recipeUserobjectId: AddProfileBookMark.recipeUserobjectId, recipeUserImageUrl: AddProfileBookMark.recipeImageUrl)), at: 0)

                //ProfileBookMarkArray.profileBookMark.append(ProfileBookMark(recipeObjectId: AddProfileBookMark.recipeObjectId, recipeTitle:  AddProfileBookMark.recipeTitle, recipeDescription: AddProfileBookMark.recipeDescription,  recipeCreateTime: AddProfileBookMark.recipeCreateTime, recipeImageUrl:AddProfileBookMark.recipeImageUrl, recipeUserName: AddProfileBookMark.recipeUserName, bookMark: AddProfileBookMark.bookMark, recipeUserobjectId: AddProfileBookMark.recipeUserobjectId))
                print("success")
            }
            else {
                print(error?.localizedDescription ?? "Server Error")
        }})
    }

    //Mark: - Remove BookMark API
    func removeBookMark() {
         let removeBookMark = PFQuery(className:"Bookmarks")
         removeBookMark.whereKey("user", equalTo: PFUser.current()!)
         removeBookMark.includeKey("relationKey")
         removeBookMark.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    let recipe:PFObject = object["relationKey"] as! PFObject
                    if recipe.objectId == DashBoardArray.removeBookMark {
                        object.deleteEventually()
                    }
                }
                 if ProfileBookMarkArray.profileBookMark.count != 0 {
                    ProfileBookMarkArray.profileBookMark = ProfileBookMarkArray.profileBookMark.filter { $0.recipeObjectId != DashBoardArray.removeBookMark }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == trendingTableView {
            let indexPath = trendingTableView.indexPathForSelectedRow
            RecipeDetail.recipeObjectId = RecipeArray.recipeDisplay[(indexPath?.row)!].recipeObjectId
            RecipeDetail.recipeUserObjectId = RecipeArray.recipeDisplay[(indexPath?.row)!].recipeUserobjectId
            navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
            DashBoard.bookMark = RecipeArray.recipeDisplay[(indexPath?.row)!].bookMark
            DashBoard.bookMarkIndex = indexPath?.row
        } else {
            let indexPath = dropDownTableView.indexPathForSelectedRow!
            if PFUser.current()?.objectId != nil {
                searchDisplayString = searchStringArray[indexPath.row]
                searchCollectionView.isHidden = false
            } else {
                recentTagViewHeightConstraint.constant = 1
            }
            dropDownTableView.isHidden = true
            recipeSearchTextField.text = searchDisplayString
            searchCollectionView.isHidden = true
            recipeCancelButtonAction.isHidden = false
            searchDisplayRecipe()
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cellHeightsDictionary[indexPath] = CGFloat(exactly: cell.frame.size.height)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeightsDictionary[indexPath] as? NSNumber
        if height != nil {
            return CGFloat(height?.doubleValue ?? 0.0)
        }
        return UITableViewAutomaticDimension
    }

    func searchDisplayRecipe() {
        spinnerView.isHidden = false
        recipesNullView.isHidden = true
        let recipeTitleQuery = PFQuery(className: "Recipe")
        recipeTitleQuery.whereKey("recipeTitle", matchesRegex: searchDisplayString, modifiers: "i")

        let recipeIngredientQuery = PFQuery(className: "Recipe")
        recipeTitleQuery.whereKey("recipeIngredient", matchesRegex: searchDisplayString, modifiers: "i")

        let query = PFQuery.orQuery(withSubqueries: [recipeTitleQuery, recipeIngredientQuery])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
        if let error = error {
            // The request failed
            print("error")
            print(error.localizedDescription)
            self.spinnerView.isHidden = true
        } else if let objects = objects {
            SearchCollectionArray.collection.removeAll()
            objects.forEach { (object) in
                    print("search i sworking")
                    if object["recipeMode"] as? String == "0" {
                        if object["recipeTitle"] != nil {
                            if ((object["recipeTitle"] as? String)?.containsIgnoringCase(find: self.searchDisplayString))! {
                               // self.SearchRecipe.append(object["recipeTitle"] as! String)
                               let searchRecipeImageFile = object["recipeImage"] as! PFFileObject
                                SearchCollectionArray.collection.append(SearchRecipe(searchRecipeName: object["recipeTitle"] as! String, searchRecipeObjectId: object.objectId!, searchRecipeImageUrl: searchRecipeImageFile.url!))
                            }
                        }

                        if object["recipeIngredient"] != nil {
                            var array = [String]()
                            array = object["recipeIngredient"] as! [String]
                            for (i,_) in array.enumerated() {
                                if array[i].containsIgnoringCase(find: self.searchDisplayString) {
                                     let searchRecipeImageFile = object["recipeImage"] as! PFFileObject
                                     SearchCollectionArray.collection.append(SearchRecipe(searchRecipeName: object["recipeTitle"] as! String, searchRecipeObjectId: object.objectId!, searchRecipeImageUrl: searchRecipeImageFile.url!))
                                }
                            }
                        }
                    }
                }

                SearchCollectionArray.collection =  SearchCollectionArray.collection.removeDuplicates()
                if SearchCollectionArray.collection.count == 0 {
                    self.recipesNullView.isHidden = false
                    self.searchCollectionView.isHidden = true
                    self.recipeNullLabel.text = "Looks like there aren't any recipes containing \(String(describing: self.recipeSearchTextField.text))"
                } else {
                    self.recipesNullView.isHidden = true
                    self.searchCollectionView.isHidden = false
                    self.searchCollectionView.reloadData()
                }
                //recipesNullView



                self.recentTagViewHeightConstraint.constant = self.recentTagView.intrinsicContentSize.height
                if PFUser.current()?.objectId != nil {
                    let user = PFUser.current()!


                    if self.recentSearchIngredientArray.contains(self.searchDisplayString) {
                        print("working is cute")
                    } else {
                         print("working")
                         self.recentSearchIngredientArray.append(self.searchDisplayString)
                         if self.recentSearchIngredientArray.count == 11 {
                            self.recentTagView.removeTag(self.recentSearchIngredientArray[0])
                            self.recentSearchIngredientArray.remove(at: 0)
                            //self.recentTagView.addTa
                            self.recentTagView.addTag(self.searchDisplayString)
                            user["recentSearchIngredient"] = self.recentSearchIngredientArray
                            user.saveEventually()

                        } else {
                            self.recentTagView.addTag(self.searchDisplayString)
                            self.recentSearchIngredientArray.append(self.searchDisplayString)
                            user["recentSearchIngredient"] = self.recentSearchIngredientArray
                            user.saveEventually()
                        }
                        self.recentTagViewHeightConstraint.constant = self.recentTagView.intrinsicContentSize.height
                    }
                }
                self.spinnerView.isHidden = true
            }
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchCollectionArray.collection.count
    }


     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchRecipeCollectionCell", for: indexPath as IndexPath) as! SearchRecipeCollectionViewCell

          cell.searchRecipeName.text = SearchCollectionArray.collection[indexPath.row].searchRecipeName
          let loadImageParams = LoadImageParams(showActivityIndicator: false)
            cell.searchRecipeImageView.loadImage(fromUrl: SearchCollectionArray.collection[indexPath.row].searchRecipeImageUrl, withParams: loadImageParams, completion: nil)

          cell.backgroundColor = .clear
          return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RecipeDetail.recipeObjectId = SearchCollectionArray.collection[(indexPath.row)].searchRecipeObjectId
        //RecipeDetail.recipeUserObjectId = SearchCollectionArray.collection[(indexPath.row)].recipeUserobjectId
         navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
    }

      // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == ingredientTagView {
            tagView.isSelected = !tagView.isSelected
            print("Remove is working")
            ingredientTagViewHeightConstraint.constant = ingredientTagView.intrinsicContentSize.height
        } else if sender == recentTagView   {
            tagView.isSelected = !tagView.isSelected
        } else {
            tagView.isSelected = !tagView.isSelected
        }

        searchCollectionView.isHidden = true
        searchDisplayString = title
        print("searchDisplayStringsearchDisplayStringsearchDisplayString\(searchDisplayString)")
        searchResultTagView.isHidden = true
        searchResultDropDownView.isHidden = false
        dropDownTableView.isHidden = true
        recipeSearchTextField.text = searchDisplayString
        recipeCancelButtonAction.isHidden = false
        //searchResultTagView.isHidden = true
        searchDisplayRecipe()
        //searchResultDropDownView.isHidden
    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Remove is working")
        sender.removeTagView(tagView)
        if sender == ingredientTagView {
            for (i, index) in addIngredientArray.enumerated() {
                if title == index {
                    addIngredientArray.remove(at: i)
                }
            }
            ingredientTagViewHeightConstraint.constant = ingredientTagView.intrinsicContentSize.height
             let user = PFUser.current()!
             user["userAddIngredient"] = addIngredientArray
             user.saveEventually()
        } else if sender == recentTagView {
             recentTagViewHeightConstraint.constant = recentTagView.intrinsicContentSize.height
        }

        popularTageViewHeightConstrint.constant = popularTagView.intrinsicContentSize.height
    }
}


extension Date {

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

}



extension UITableView {

    func reloadWithoutAnimation() {
        let lastScrollOffset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }
}
