//
//  RecipeDetailViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 26/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//


class replyCountObject:NSObject {

    var commentObjectId:String = ""
    var count:Int = 0

    init (commentObjectId:String, count:Int) {
        self.commentObjectId = commentObjectId
        self.count = count
    }
}

struct replyCountArray {
    static var reply = [replyCountObject]()
}


class CommentUser:NSObject {

    var commentObjectId:String = ""
    var commentBool:Bool = false

    init (commentObjectId:String, commentBool:Bool) {
        self.commentObjectId = commentObjectId
        self.commentBool = commentBool
    }
}

struct CommentUserArray {
    static var comment = [CommentUser]()
}

import UIKit
import Parse
import EasyPopUp

class RecipeDetailViewController: UIViewController {

   // Mark: - @IBOutlets
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var segmentTitle: ScrollableSegmentedControl!
    @IBOutlet var ingredientsView: UIView!
    @IBOutlet var preparationView: UIView!
    @IBOutlet var commentsView: UIView!
    @IBOutlet var shadowImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var ingredientViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var ingredientViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var preparationViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var preparationViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var commentsViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var commentsViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var topView: UIView!

    @IBOutlet weak var recipeDetailScrollView: UIScrollView!
    @IBOutlet var hideCookwareView: UIView!
    @IBOutlet var hideCookWareTableView: UITableView!
    @IBOutlet var hideCookWareHeightConstaint: NSLayoutConstraint!
    @IBOutlet var ingedientsTableView: UITableView!
    @IBOutlet var ingedientsHeightConstaint: NSLayoutConstraint!
    @IBOutlet var ingredientListView: UIView!
    @IBOutlet var preparationTableView: UITableView!
    @IBOutlet var preparationHeightConstaint: NSLayoutConstraint!
    @IBOutlet var floatRatingReview: FloatRatingView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet var hideCookWareLineImageView: UIImageView!
    @IBOutlet var hideCookWareButton: UIButton!
    @IBOutlet weak var viewCookWareViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet var recipeTitleLable: UILabel!
    @IBOutlet var recipeUserNameLabel: UILabel!
    @IBOutlet var preparationTimeLable: UILabel!
    @IBOutlet var servingsLabel: UILabel!
    @IBOutlet var recipeDescriptionLabel: UILabel!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet var bookMarkView: UIView!
    @IBOutlet var bookMarkViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var bookMarkButton: UIButton!
    @IBOutlet var topConsraint: NSLayoutConstraint!

    // Mark: - Preparation
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var recipeUserImageView: UIImageView!

    @IBOutlet weak var bookMarkLabel: UILabel!
    @IBOutlet weak var unCheckImage: UIImageView!



    // Mark: - Declaration
    let screenSize = UIScreen.main.bounds
    var hideCookwareHeight:CGFloat = 0.0
    var hideCookwareBool:Bool = true
    var ingredientHeight:CGFloat = 0.0
    var ingredientViewHeight:CGFloat = 0.0
    var ingredientBoolArray = [Bool]()
    var preparationHeight:CGFloat = 0.0
    var bookMark:Bool = false
    var totalCalories:Double = 0.0
    var commentObjectId:String = ""
    var commentObjectIdArray = [String]()
    var replyCount = [Int]()
    var commentTableViewContentSizeHeight:CGFloat = 0.0
    var commentHeight:CGFloat = 0.0
    var commentBool:Bool = false
    var likeCount:Int = 0
    var commentUserBoolArray = [Bool]()
    var totalRating:Double = 0
    var totalRatingCount:Double = 0
    var addBookMarkBool:Bool = true

    @IBOutlet var userLoginPopUpView: UIView!

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerInsiedView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    var popUpConfig = EasyPopupConfig()

    // Mark: - User Login PopUp
     lazy var userLoginPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: userLoginPopUpView)
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

    func userLoginPopUpShow() {
        userLoginPopUp.showPopup { (isfinished) in
            print(isfinished)
        }
    }


    @IBAction func cancelPopUpButtonAction(_ sender: AnyObject) {
        userLoginPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadSpinnerView()
        setUpSegment()
        self.bookMarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        hideCookWareReuseIdentifier()
        ingredientsReuseIdentifier()
        preparationReuseIdentifier()
        commentsReuseIdentifier()
        getRecipeDetails()
        getComments()
        self.tabBarController?.tabBar.isHidden = true

        if PFUser.current()?.objectId != nil {
            recentlyView()
            getBookmark()
        }


        if PFUser.current()?.objectId == RecipeDetail.recipeUserObjectId {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(RecipeDetailViewController.tapFunction))
        bookMarkLabel.isUserInteractionEnabled = true
        bookMarkLabel.addGestureRecognizer(tap)

        bookMarkButton.contentVerticalAlignment = .fill
        bookMarkButton.contentHorizontalAlignment = .fill
       // LoadSpinnerView()
        //bookMarkView.frame = CGRect(x:self.bookMarkView.frame.origin.x, y:self.topView.frame.maxY - 50, width:self.bookMarkView.frame.width, height:self.bookMarkView.frame.height)
    }

    func getBookmark() {
        if DashBoard.bookMark == "1" {
            addBookMarkBool = true
            self.bookMarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            bookMarkLabel.text = "UnBookmark"
            bookMarkLabel.textColor = UIColor._lightGray3
            unCheckImage.image = nil
            self.bookMarkButton.setImage(#imageLiteral(resourceName: "Bookmarked_orange"), for: .normal)
        } else {
            addBookMarkBool = false
            self.bookMarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            bookMarkLabel.text = "Bookmark"
            bookMarkLabel.textColor = UIColor._lightningYellow
            unCheckImage.image = #imageLiteral(resourceName: "orange_check")
            self.bookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark_grey"), for: .normal)
        }
    }

    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if addBookMarkBool == true {
            self.bookMarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            addBookMarkBool = false
            self.bookMarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            bookMarkLabel.text = "Bookmark"
            bookMarkLabel.textColor = UIColor._lightningYellow
            unCheckImage.image = #imageLiteral(resourceName: "orange_check")
            self.bookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark_grey"), for: .normal)
            RemoveBookmark()
            RecipeArray.recipeDisplay.filter({$0.recipeObjectId == RecipeDetail.recipeObjectId}).first?.bookMark = "0"
        } else {
            self.bookMarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            addBookMarkBool = true
            self.bookMarkButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            bookMarkLabel.text = "UnBookmark"
            bookMarkLabel.textColor = UIColor._lightGray3
            unCheckImage.image = nil
            self.bookMarkButton.setImage(#imageLiteral(resourceName: "Bookmarked_orange"), for: .normal)
            addBookmark()
            RecipeArray.recipeDisplay.filter({$0.recipeObjectId == RecipeDetail.recipeObjectId}).first?.bookMark = "1"
        }
    }

    func LoadSpinnerView() {
        spinnerInsiedView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerInsiedView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.commentsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        if RecipeDetail.commentsBool == true {
            RecipeDetail.commentsBool = false
            commentBool = true
            commentsTableView.reloadData()
        }
        shadowImageView.addTopBorderWithColor(color: UIColor._bottomBorderGray, width: 1.0, view: shadowImageView)
        recipeImageView.clipsToBounds = true
        hideNavigationBar()
    }

     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                commentTableViewContentSizeHeight = newsize.height
            }
            if commentBool == true {
                shadowImageViewHeightConstraint.constant = 80 + commentTableViewContentSizeHeight
            }

        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.commentsTableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }

    // Mark: - RecentlyViewed
    func recentlyView() {
        let recentlyView = PFQuery(className:"RecentlyView")
        recentlyView.whereKey("user", equalTo: PFUser.current()!)
        recentlyView.includeKey("relationKey")
        recentlyView.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    let recipe:PFObject = object["relationKey"] as! PFObject
                    if RecipeDetail.recipeObjectId == recipe.objectId {
                        object.deleteEventually()
                    }
                }
                self.addRecentlyViewed()
            }
        }
    }

    // Mark: - Add Recently Viewed
    func addRecentlyViewed() {
        let recentlyView = PFObject(className:"RecentlyView")
        let recipe = PFObject(className:"Recipe")
        recentlyView["relationKey"] = recipe
        recentlyView["relationKey"] = PFObject(withoutDataWithClassName:"Recipe",  objectId:(RecipeDetail.recipeObjectId))
        recentlyView["user"] = PFUser.current()!
         recentlyView.saveInBackground(block: { (success, error) in
            if error == nil {
                print("success")
            }
            else {
                print(error?.localizedDescription ?? "Server Error")
        }})
    }

    func getComments() {
        let commentRecipe = PFQuery(className:"Comments")
        commentRecipe.whereKey("recipeId", equalTo: RecipeDetail.recipeObjectId)
        commentRecipe.order(byDescending: "createdAt")
        commentRecipe.includeKey("userRelationKey")
        CommentsArray.comments.removeAll()
        commentRecipe.findObjectsInBackground(block: { (comments: [PFObject]?, error: Error?) in
            if let error = error {
                // There was an error
                print(error.localizedDescription)
            } else {
                for comment in comments! {
                    self.commentObjectId = comment.objectId ?? ""
                    self.commentObjectIdArray.append(comment.objectId ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let user:PFUser = comment["userRelationKey"] as! PFUser
                   // let commentUserImageFile = comment["profilePicture"] as! PFFileObject
                        let rating = comment["rating"] as! Double
                        if rating != 0 {
                            self.totalRating = self.totalRating + rating
                            self.totalRatingCount = self.totalRatingCount + 1
                            print(self.totalRating)
                            print(self.totalRatingCount )
                        }

                        if self.totalRatingCount != 0 {
                            self.floatRatingReview.rating = self.totalRating / self.totalRatingCount
                            self.ratingCountLabel.text = "(\(String(Int(self.totalRatingCount))))"
                            self.floatRatingReview.isHidden = false
                            self.ratingCountLabel.isHidden = false
                        } else {
                            self.floatRatingReview.isHidden = true
                            self.ratingCountLabel.isHidden = true
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


                        
                       var commentImageFile:PFFileObject!
                       if comment["commentImage"] != nil {
                        commentImageFile = comment["commentImage"] as? PFFileObject
                        CommentsArray.comments.append(Comments(profileImageUrl: "", username: user["userDisplayName"] as! String, rating: comment["rating"] as! Double, commentImageUrl: commentImageFile.url!, comment: comment["comment"] as! String, time: String(describing:  comment.createdAt?.toLocalTime()), replyCount:0, likeCount: comment["likesCount"] as! Int, commentObjectID:  comment.objectId!, likeCommentBool: false, userObjectId: user.objectId!, commentUserImageUrl: recipeUserImageUrl))
                        } else {
                        CommentsArray.comments.append(Comments(profileImageUrl: "", username:  user["userDisplayName"] as! String, rating: comment["rating"] as! Double, commentImageUrl: "", comment: comment["comment"] as! String, time: String(describing: comment.createdAt?.toLocalTime()), replyCount: 0, likeCount: comment["likesCount"] as! Int, commentObjectID:  comment.objectId!, likeCommentBool: false, userObjectId: user.objectId!, commentUserImageUrl: recipeUserImageUrl))
                        }
                    }

                }
                self.replyCountAPI()

            }
        })
    }

    func replyCountAPI() {
        for (_, index) in commentObjectIdArray.enumerated() {
             let query = PFQuery(className:"Reply")
             query.whereKey("commentObjectId", equalTo:index)
             query.countObjectsInBackground { (count: Int32, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    replyCountArray.reply.append(replyCountObject(commentObjectId: index, count: Int(count)))
                }
            }
        }

        if PFUser.current()?.objectId != nil {
            commentUserBool()
        }
    }

    func commentUserBool() {
        for (_, index) in commentObjectIdArray.enumerated() {
            let likeComment = PFQuery(className:"CommentLikes")
            //likeComment["commentId"] = commentObjectId

            likeComment.whereKey("commentId", equalTo:index)
            likeComment.whereKey("user", equalTo:PFUser.current()!)
           // likeComment["userId"] = PFUser.current()?.objectId
            likeComment.countObjectsInBackground { (count: Int32, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if count == 0 {
                        CommentUserArray.comment.append(CommentUser(commentObjectId: index, commentBool: false))
                    } else {
                        CommentUserArray.comment.append(CommentUser(commentObjectId: index, commentBool: true))
                    }

                    if CommentsArray.comments.count == CommentUserArray.comment.count {
                        self.commentsTableView.reloadData()
                    }
                }
            }
        }
    }

     // Mark: - Get BookMark
//    func getBookmark() {
//        let bookmark = PFQuery(className:"Bookmarks")
//        bookmark.whereKey("user", equalTo: PFUser.current()!)
//        bookmark.includeKey("relationKey")
//        bookmark.order(byDescending: "createdAt")
//        bookmark.findObjectsInBackground { (objects, error) in
//            if error != nil {
//                print(error?.localizedDescription ?? "")
//            } else {
//                 DashBoardArray.bookMark.removeAll()
//                 for object in objects! {
//                    let recipe:PFObject = object["relationKey"] as! PFObject
//                    if RecipeDetail.recipeObjectId == recipe.objectId! {
//                      //  self.bookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark orange.png"), for: .normal)
//                        self.addBookMarkBool = true
//                        self.bookMarkLabel.text = "UnBookMark"
//                        self.bookMarkLabel.textColor = UIColor._lightGray3
//                        self.bookMarkButton.setImage(#imageLiteral(resourceName: "Bookmarked_orange"), for: .normal)
//                        self.unCheckImage.image = #imageLiteral(resourceName: "orange_check")
//
//                    } else {
//                        self.addBookMarkBool = false
//                        self.bookMarkLabel.text = "Bookmarked"
//                        self.unCheckImage.image = nil
//                        self.bookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark_grey"), for: .normal)
//                        self.bookMarkLabel.tintColor = UIColor._lightningYellow
//                    }
//                }
//            }
//        }
//    }

    // Mark: - Get RecipeDetails
    func getRecipeDetails() {
        spinnerView.isHidden = false
        let query = PFQuery(className:"Recipe")
        query.includeKey("relationKey")
        query.getObjectInBackground(withId: RecipeDetail.recipeObjectId) { (recipeDetail: PFObject?, error: Error?) in
            if let error = error {
                //The query returned an error
                print(error.localizedDescription)
            } else {
                //The object has been retrieved
                let recipeImageFile = recipeDetail!["recipeImage"] as! PFFileObject
                RecipeDetail.recipeImageUrl = recipeImageFile.url!
                RecipeDetail.recipeTitle = recipeDetail!["recipeTitle"] as! String
                RecipeDetail.recipeDescription = recipeDetail!["recipeDescription"] as! String 
                RecipeDetail.preparationTime = recipeDetail!["preparationTime"] as! String
                RecipeDetail.servings = recipeDetail!["servings"] as! String
                RecipeDetail.cookWareArray = recipeDetail!["recipeCookWare"] as! [String]
                RecipeDetail.ingredientArray = recipeDetail!["recipeIngredient"] as! [String]
                RecipeDetail.ingredientAmountArray = recipeDetail!["recipeIngredientAmount"] as! [String]
                RecipeDetail.preparationArray = recipeDetail!["recipeAddStep"] as! [String]
                let user:PFUser = recipeDetail!["relationKey"] as! PFUser
                RecipeDetail.recipeUserName = user["userDisplayName"] as! String

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
                 RecipeDetail.recipeUserimageUrl = recipeUserImageUrl

                 RecipeDetail.nutritionFacts = recipeDetail!["nutritionFacts"] as! [[String:AnyObject]]
                self.displayRecipeDetails()
            }
        }
    }

    // Mark: - Display RecipeDetails
    func displayRecipeDetails() {
        let loadImageParams = LoadImageParams(showActivityIndicator: false, forceRefresh: true)
        recipeImageView.loadImage(fromUrl: RecipeDetail.recipeImageUrl, withParams: loadImageParams, completion: nil)
        recipeUserImageView.loadImage(fromUrl: RecipeDetail.recipeUserimageUrl, withParams: loadImageParams, completion: nil)
        recipeTitleLable.text = RecipeDetail.recipeTitle
        recipeTitleLable.text = RecipeDetail.recipeTitle
        recipeDescriptionLabel.text = RecipeDetail.recipeDescription
        preparationTimeLable.text = RecipeDetail.preparationTime
        recipeUserNameLabel.text = RecipeDetail.recipeUserName


        //recipeUserImageView.
        //RecipeDetail.recipeUserimageUrl

        servingsLabel.text = "\(RecipeDetail.servings) SERVINGS"
        RecipeDetail.ingredientArray.append("Add All")
        RecipeDetail.ingredientAmountArray.append("")
        ingedientsTableView.reloadData()
        hideCookWareTableView.reloadData()
        preparationTableView.reloadData()

        for nutrition in RecipeDetail.nutritionFacts {
            let calories = nutrition["calories"] as! Double
            totalCalories = totalCalories + calories
        }
        if totalCalories == 0.0 {
            totalCaloriesLabel.text = "\(0.1) CALORIES"
        } else {
            totalCaloriesLabel.text = "\(totalCalories) CALORIES"
        }

        self.spinnerView.isHidden = true

        //self.shadowImageViewHeightConstraint.constant = self.ingredientListView.frame.origin.y + self.ingedientsHeightConstaint.constant + 34 - hideCookwareHeight
    }

     // Mark: - CookWare Reuse Identifier
     func hideCookWareReuseIdentifier() {
        hideCookWareTableView.delegate = self
        hideCookWareTableView.dataSource = self
        recipeDetailScrollView.delegate = self
        hideCookWareTableView.register(UINib(nibName: TableViewCell.ClassName.cookWare, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.cookWare)
        hideCookWareTableView.backgroundColor = UIColor.clear
        hideCookWareTableView.separatorColor = UIColor._lightGraySeparator
    }

    // Mark: - Ingredients Reuse Identifier
    func ingredientsReuseIdentifier() {
        ingedientsTableView.delegate = self
        ingedientsTableView.dataSource = self
        ingedientsTableView.tableFooterView = UIView()
        ingedientsTableView.register(UINib(nibName: TableViewCell.ClassName.ingredients, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.ingredients)
        ingedientsTableView.tableFooterView = UIView()
        ingedientsTableView.separatorColor = UIColor._lightGraySeparator
        hideCookWareTableView.reloadData()
    }

     // Mark: - Ingredients Reuse Identifier
    func commentsReuseIdentifier() {
       commentsTableView.delegate = self
        commentsTableView.dataSource = self
       // commentsTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old, .prior], context: nil)
        commentsTableView.tableFooterView = UIView()
        commentsTableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier:  "Comments")
        //commentsTableView.tableFooterView = UIView()
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        commentsTableView.backgroundColor = UIColor.clear
        //commentsTableView.reloadData()
    }


    // Mark: - Preparation Reuse Identifier
    func preparationReuseIdentifier() {
        preparationTableView.delegate = self
        preparationTableView.dataSource = self
        preparationTableView.register(UINib(nibName: TableViewCell.ClassName.preparation, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.preparation)
        preparationTableView.rowHeight = UITableViewAutomaticDimension
        preparationTableView.separatorStyle = .none
        preparationTableView.backgroundColor = UIColor.clear

    }

    // Mark: - Segment Control
    func setUpSegment() {
        segmentTitle.segmentStyle = .textOnly
        segmentTitle.insertSegment(withTitle: "Ingredients", image: nil, at: 0)
        segmentTitle.insertSegment(withTitle: "Preparation", image: nil, at: 1)
        segmentTitle.insertSegment(withTitle: "Comments", image: nil, at: 2)
        segmentTitle.underlineSelected = true
        segmentTitle.selectedSegmentIndex = 0
        segmentTitle.fixedSegmentWidth = true
        segmentTitle.tintColor = UIColor._lightningYellow

        preparationViewLeadingConstraint.constant = screenSize.width
        preparationViewTrailingConstraint.constant = -screenSize.width

        commentsViewLeadingConstraint.constant = 2 * screenSize.width
        commentsViewTrailingConstraint.constant = -2 * screenSize.width

        // Mark: - Tablayout Animation
        segmentTitle.addTarget(self, action: #selector(RecipeDetailViewController.segmentSelected(sender:)), for: .valueChanged)
       }

    // Mark: - Segment Control Select Action
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.ingredientViewAnimation()
            })
        } else if sender.selectedSegmentIndex == 1 {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.preparationViewAnimation()
                })
        } else {

             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.commentsViewAnimation()
                self.view.layoutIfNeeded()
             })
        }
    }      

    // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // Mark: - TabLayout Animation for Ingredient View
    func ingredientViewAnimation() {
        commentBool = false
        ingredientViewLeadingConstraint.constant = 0
        ingredientViewTrailingConstraint.constant = 0
        preparationViewLeadingConstraint.constant = screenSize.width
        preparationViewTrailingConstraint.constant = -screenSize.width
        commentsViewLeadingConstraint.constant = 2 * screenSize.width
        commentsViewTrailingConstraint.constant = -2 * screenSize.width
        self.shadowImageViewHeightConstraint.constant = ingredientHeight
        self.view.layoutIfNeeded()

        if hideCookwareBool == false {
            viewCookWareViewHeightConstraint.constant = hideCookWareButton.frame.height + hideCookwareHeight
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.hideCookWareTableView.reloadData()
            }
        }
    }

    // Mark: - TabLayout Animation for Ingredient View
    func preparationViewAnimation() {
        commentBool = false
        ingredientViewLeadingConstraint.constant = -screenSize.width
        ingredientViewTrailingConstraint.constant = screenSize.width
        preparationViewLeadingConstraint.constant = 0
        preparationViewTrailingConstraint.constant = 0
        commentsViewLeadingConstraint.constant =  screenSize.width
        commentsViewTrailingConstraint.constant = -screenSize.width
        shadowImageViewHeightConstraint.constant = preparationHeight
        self.view.layoutIfNeeded()
    }

    // Mark: - TabLayout Animation for Ingredient View
    func commentsViewAnimation() {
        self.commentBool = true
        self.commentsTableView.reloadData()
        ingredientViewLeadingConstraint.constant = 2 * -screenSize.width
        ingredientViewTrailingConstraint.constant = 2 * screenSize.width
        preparationViewLeadingConstraint.constant = -screenSize.width
        preparationViewTrailingConstraint.constant = screenSize.width
        commentsViewLeadingConstraint.constant =  0
        commentsViewTrailingConstraint.constant = 0
          //  shadowImageViewHeightConstraint.constant = 80 + commentTableViewContentSizeHeight
        self.view.layoutIfNeeded()
    }


    // Mark: - Hide CookWare Button Action
    @IBAction func hideCookwareButtonAction(_ sender: Any) {
         hideCookWareTableView.reloadData()
        if hideCookwareBool == true {
            hideCookwareBool = false
            hideCookWareHeightConstaint.constant = hideCookwareHeight
            hideCookWareLineImageView.backgroundColor = UIColor._lightGraySeparator
            hideCookWareLineImageView.isHidden = false
            hideCookWareButton.setTitle("HIDE COOKWARE", for: .normal)
            viewCookWareViewHeightConstraint.constant = hideCookWareButton.frame.height + hideCookwareHeight
            self.shadowImageViewHeightConstraint.constant = self.ingredientListView.frame.origin.y + ingredientViewHeight + hideCookwareHeight
            ingredientHeight = self.shadowImageViewHeightConstraint.constant
            viewCookWareViewHeightConstraint.constant = hideCookWareButton.frame.height + hideCookwareHeight
            self.view.layoutIfNeeded()
        } else {
            hideCookwareBool = true
            hideCookWareHeightConstaint.constant = 0
            hideCookWareButton.setTitle("VIEW COOKWARE", for: .normal)
            hideCookWareLineImageView.isHidden = true
            viewCookWareViewHeightConstraint.constant = 30
             self.shadowImageViewHeightConstraint.constant = self.ingredientListView.frame.origin.y + ingredientViewHeight - hideCookwareHeight
             ingredientHeight = self.shadowImageViewHeightConstraint.constant
               self.view.layoutIfNeeded()
        }
    }

    // Mark: - Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // Mark: - BookMark Button Action
    @IBAction func bookMarkButtonAction(_ sender: Any) {
        if PFUser.current()?.objectId != nil {
            if bookMark == false {
                bookMarkViewShow()
            } else {
                bookMarkViewHide()
            }
        } else {
            userLoginPopUpShow()
        }
    }

     // Mark: - BookMark Button Action
      func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if bookMark == true {
            bookMarkViewHide()
        }
    }

    // Mark: - BookMark Show
    func bookMarkViewShow() {
        bookMark = true
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.topConsraint.constant = 0
            self.view.layoutIfNeeded()
           // self.bookmark()
        })
    }

    // Mark: - BookMark Hide
    func bookMarkViewHide() {
        bookMark = false
         UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.topConsraint.constant = -50
            self.view.layoutIfNeeded()
        })
    }

    // Mark: - Get BookMark
    func RemoveBookmark() {
        let recentlyView = PFQuery(className:"Bookmarks")
        recentlyView.whereKey("user", equalTo: PFUser.current()!)
        recentlyView.includeKey("relationKey")
        recentlyView.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    let recipe:PFObject = object["relationKey"] as! PFObject
                    if RecipeDetail.recipeObjectId == recipe.objectId {
                        object.deleteEventually()
                    }
                }
            }
        }
    }

    // Mark: - Add BookMark
    func addBookmark() {
        let bookmarks = PFObject(className:"Bookmarks")
        let recipe = PFObject(className:"Recipe")
        let user = PFUser.current()

        bookmarks["relationKey"] = recipe
        bookmarks["user"] = user
        bookmarks["relationKey"] = PFObject(withoutDataWithClassName:"Recipe",  objectId:(RecipeDetail.recipeObjectId))
        
         bookmarks.saveInBackground(block: { (success, error) in
            if error == nil {
                print("success")
            }
            else {
                print(error?.localizedDescription ?? "Server Error")
        }})
    }

    // Mark: - Add To Collection Button Action
    @IBAction func addToCollectionButtonAction(_ sender: Any) {
        //RecipeDetail.recipeimage = recipeImageView.image!
        navigationPushRedirect(storyBoardName: "RecipeDetail", storyBoardId: "AddToCollection")
    }

    @IBAction func viewNutritionFactsButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: "RecipeDetail", storyBoardId: "nutritionFacts")
    }

    @IBAction func addCommentButtonAction(_ sender: Any) {
        if PFUser.current()?.objectId != nil {
            navigationPushRedirect(storyBoardName: "RecipeDetail", storyBoardId: "AddComment")
        } else {
            userLoginPopUpShow()
        }
    }

    @IBAction func editButtonAction(_ sender: Any) {
        getRecipe.recipeObjectId = RecipeDetail.recipeObjectId
        navigationPushRedirect(storyBoardName: "AddRecipe", storyBoardId: "EditRecipe")
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

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //MARK: - Hide CookWare TableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hideCookWareTableView {
            return RecipeDetail.cookWareArray.count
        } else if tableView == ingedientsTableView {
            return RecipeDetail.ingredientArray.count
        } else if tableView == preparationTableView {
            return RecipeDetail.preparationArray.count
        } else {
            return CommentsArray.comments.count
        }
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == preparationTableView {
            return UITableViewAutomaticDimension
        } else if tableView == commentsTableView {
            return UITableViewAutomaticDimension
        } else {
            return 50.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hideCookWareTableView {
            let cell = hideCookWareTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.cookWare) as! hideCookWareTableViewCell
            cell.hideCookWareLabel.text = RecipeDetail.cookWareArray[indexPath.row]
           // hideCookwareHeight = hideCookWareTableView.contentSize.height + 5
           if  hideCookwareBool == false {
                hideCookwareHeight = 50.0 * CGFloat(RecipeDetail.cookWareArray.count) + 17
            }
            hideCookwareHeight = 50.0 * CGFloat(RecipeDetail.cookWareArray.count)

            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            return cell
        } else if tableView == ingedientsTableView {
            let cell = ingedientsTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.ingredients) as! IngredientsTableViewCell
            if indexPath.row == RecipeDetail.ingredientArray.count - 1 {
                cell.ingredientsName.font = UIFont(name:"SourceSansPro-Bold", size: 14.0)
            } else {
                ingredientBoolArray.append(true)
            }
            cell.selectionStyle = .none
            cell.ingredientsName.text = "\(RecipeDetail.ingredientAmountArray[indexPath.row]) \(RecipeDetail.ingredientArray[indexPath.row])"
            cell.ingredientAddImageView.image = #imageLiteral(resourceName: "circlePlus")
            ingredientViewHeight = (50.0 * CGFloat(RecipeDetail.ingredientArray.count)) + 17
            ingedientsHeightConstaint.constant =  ingredientViewHeight
            shadowImageViewHeightConstraint.constant = self.ingredientListView.frame.origin.y + ingedientsHeightConstaint.constant
            self.ingredientHeight = self.shadowImageViewHeightConstraint.constant
            return cell
        } else  if tableView == preparationTableView {
            let cell = preparationTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.preparation) as! PreparationTableViewCell
            cell.countLabel.text = String(indexPath.row + 1)
            cell.preparationLabel.text = RecipeDetail.preparationArray[indexPath.row]
            cell.selectionStyle = .none
            preparationHeightConstaint.constant = preparationTableView.contentSize.height + 15
            self.preparationHeight =  self.preparationHeightConstaint.constant + 64
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = commentsTableView.dequeueReusableCell(withIdentifier:  "Comments") as! CommentsTableViewCell
             cell.backgroundColor = UIColor.clear
            commentsTableView.separatorStyle = .none
            let loadImageParams = LoadImageParams(showActivityIndicator: false, resizeBeforeCaching: true)
           // cell.userProfileImageView.loadImage(fromUrl: CommentsArray.comments[indexPath.row].profileImageUrl, withParams: loadImageParams, completion: nil)
            cell.commentImageView.loadImage(fromUrl: CommentsArray.comments[indexPath.row].commentImageUrl, withParams: loadImageParams, completion: nil)
            cell.usernameLabel.text = CommentsArray.comments[indexPath.row].username

            if CommentsArray.comments[indexPath.row].commentUserImageUrl != "" {
                 cell.userProfileImageView.loadImage(fromUrl: CommentsArray.comments[indexPath.row].commentUserImageUrl, withParams: loadImageParams, completion: nil)
            } else {
                 cell.userProfileImageView.image = #imageLiteral(resourceName: "Profile")
            }


            cell.commentLabel.text = CommentsArray.comments[indexPath.row].comment
            cell.commentTimeLabel.text = currentTime(time: CommentsArray.comments[indexPath.row].time)
            cell.replyButton.setTitle("·   View \(CommentsArray.comments[indexPath.row].replyCount) replies", for: .normal)
            cell.likeCountLabel.text = String(CommentsArray.comments[indexPath.row].likeCount)

            for (i, _) in replyCountArray.reply.enumerated() {
                if replyCountArray.reply[i].commentObjectId == CommentsArray.comments[indexPath.row].commentObjectID {
                     if replyCountArray.reply[i].count == 0 {
                        cell.replyButton.setTitle("·   reply", for: .normal)
                    } else {
                        cell.replyButton.setTitle("·   View \(replyCountArray.reply[i].count) replies", for: .normal)
                    }
                }
            }

             for (i, _) in CommentUserArray.comment.enumerated() {
                if CommentUserArray.comment[i].commentObjectId == CommentsArray.comments[indexPath.row].commentObjectID {
                    if CommentUserArray.comment[i].commentBool == false {
                        cell.likeButton.isUserInteractionEnabled = true
                    } else {
                        cell.likeButton.isUserInteractionEnabled = false
                    }
                }
             }

            if CommentsArray.comments[indexPath.row].likeCount == 0 {
                cell.likeCountLabel.text = ""
            } else {
                cell.likeCountLabel.text = String(CommentsArray.comments[indexPath.row].likeCount)
            }

            if CommentsArray.comments[indexPath.row].rating == 0 {
                cell.rating.isHidden = true
            } else {
                cell.rating.isHidden = false
                cell.rating.rating = CommentsArray.comments[indexPath.row].rating
            }

            cell.replyButton.tag = indexPath.row
            cell.replyButton.addTarget(self, action: #selector(loginbuttonAction), for: .touchUpInside)

            cell.likeButton.tag = indexPath.row
            cell.likeButton.addTarget(self, action: #selector(likeCountButtonAction), for: .touchUpInside)

            if CommentsArray.comments[indexPath.row].commentImageUrl == "" {
                cell.commentImageHeightConstraint.isActive = true
                cell.commentImageHeightConstraint.constant = 1
                cell.shadowView.shadowRadius = 0
                cell.shadowView.shadowOpacity = 0
                cell.shadowView.shadowOffset = CGSize(width: 0, height:0)
                cell.shadowView.clipsToBounds = false
                cell.shadowView.isHidden = true
                cell.shadowView.shadowColor = UIColor.clear
                cell.topView.shadowRadius = 0
                cell.topView.shadowOpacity = 0
                cell.topView.shadowOffset = CGSize(width: 0, height:0)
                cell.topView.shadowColor = UIColor.clear
                cell.commentsTopConstraint.constant = 0
                cell.viewTopConstraint.constant = -10
            } else {
                cell.commentImageHeightConstraint.isActive = true
                cell.shadowView.shadowRadius = 3
                cell.shadowView.shadowOpacity = 2
                cell.shadowView.shadowOffset = CGSize(width: 0, height:2)
                cell.shadowView.isHidden = false
                cell.shadowView.shadowColor = UIColor.gray
                cell.topView.shadowRadius = 3
                cell.topView.shadowOpacity = 2
                cell.topView.shadowOffset = CGSize(width: 0.3, height:5)
                cell.topView.shadowColor = UIColor.gray
                cell.commentsTopConstraint.constant = 14
                cell.viewTopConstraint.constant = 0
                cell.commentImageHeightConstraint.isActive = true
                cell.commentImageHeightConstraint.constant = 232

                if PFUser.current()?.objectId == CommentsArray.comments[indexPath.row].commentObjectID  {
                     cell.shadowView.clipsToBounds = false
                } else {
                    cell.shadowView.clipsToBounds = false
                }
            }

            print("CommentsArray.comments[indexPath.row].username\(CommentsArray.comments[indexPath.row].username)")
            print("cell.commentImageView.frame.height\(cell.commentImageView.frame.height)")
            print("cell.commentImageHeightConstraint.constant\(cell.commentImageHeightConstraint.constant)")

            cell.selectionStyle = .none
            return cell
        }
    }

    @objc func loginbuttonAction(sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: commentsTableView)
        let indexPath = commentsTableView.indexPathForRow(at: buttonPosition)!
        let cell = commentsTableView.cellForRow(at: indexPath) as! CommentsTableViewCell
        if CommentsArray.comments[indexPath.row].commentImageUrl != "" {
            CommentRecipe.commentImage = cell.commentImageView.image!
            CommentRecipe.imageBool = true
        } else {
            CommentRecipe.imageBool = false
        }
            CommentRecipe.commentUserName = cell.usernameLabel.text!
            CommentRecipe.repliesRatingView = cell.rating.rating
            CommentRecipe.comment = cell.commentLabel.text!
            CommentRecipe.commentTimingLabel = cell.commentTimeLabel.text!
            CommentRecipe.commentObjectId = CommentsArray.comments[indexPath.row].commentObjectID
            CommentRecipe.likeCount = cell.likeCountLabel.text!
            CommentRecipe.commentUserImage = cell.userProfileImageView.image!
            navigationPushRedirect(storyBoardName: "RecipeDetail", storyBoardId: "Replies")
    }

    @objc func likeCountButtonAction(sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: commentsTableView)
        let indexPath = commentsTableView.indexPathForRow(at: buttonPosition)!
        commentObjectId = CommentsArray.comments[indexPath.row].commentObjectID
        getLikeCommentUser(indexPath: indexPath.row)
        //likeCountAPI()
    }

    func likeCountAPI() {
        let query = PFQuery(className:"Comments")
        //query.whereKey("objectId", equalTo:commentObjectId)
        query.getObjectInBackground(withId: commentObjectId) { (object: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                object?["likesCount"] = self.likeCount
                object!.saveInBackground()
            }
        }
    }

    func likeCommentUser() {
        let likeComment = PFObject(className:"CommentLikes")
        likeComment["comment"] = PFObject(withoutDataWithClassName:"Comments",  objectId:(commentObjectId))
        likeComment["user"] = PFUser.current()!
        likeComment["commentId"] = commentObjectId
        likeComment.saveInBackground(block: { (success, error) in
        if error == nil {
            self.likeCountAPI()
        }
        else {
            print(error?.localizedDescription ?? "Server Error")
        }})
    }

    func getLikeCommentUser(indexPath:Int) {
         let query = PFQuery(className:"CommentLikes")
         query.whereKey("commentId", equalTo:commentObjectId)
         query.whereKey("user", equalTo:PFUser.current()!)
         query.countObjectsInBackground { (count: Int32, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(count)
                if count == 0 {
                    CommentsArray.comments[indexPath].likeCount = CommentsArray.comments[indexPath].likeCount + 1
                    self.likeCount = CommentsArray.comments[indexPath].likeCount
                    self.commentsTableView.reloadData()
                    self.likeCommentUser()
                } else {
                    print("already like by a user")
                }
            }
        }
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ingedientsTableView {
            let indexPath = ingedientsTableView.indexPathForSelectedRow!
            let cell = ingedientsTableView.cellForRow(at: indexPath) as! IngredientsTableViewCell
            if indexPath.row != RecipeDetail.ingredientArray.count - 1 {
                if ingredientBoolArray[indexPath.row] == true {
                    ingredientBoolArray[indexPath.row] = false
                    cell.ingredientAddImageView.image = #imageLiteral(resourceName: "circleMinize")
                }  else {
                    ingredientBoolArray[indexPath.row] = true
                    cell.ingredientAddImageView.image = #imageLiteral(resourceName: "circlePlus")
                }
            } else {
                ingredientBoolArray.removeAll()
                ingedientsTableView.reloadData()
            }
        }
    }
}

//else if tableView == commentsTableView {
//            let indexPath = commentsTableView.indexPathForSelectedRow!
//            let cell = commentsTableView.cellForRow(at: indexPath) as! CommentsTableViewCell
//             if CommentsArray.comments[indexPath.row].commentImageUrl != "" {
//                CommentRecipe.commentImage = cell.commentImageView.image!
//                CommentRecipe.imageBool = true
//            } else {
//                CommentRecipe.imageBool = false
//            }
//            CommentRecipe.commentUserName = cell.usernameLabel.text!
//            CommentRecipe.repliesRatingView = cell.rating.rating
//            CommentRecipe.comment = cell.commentLabel.text!
//            CommentRecipe.commentTimingLabel = cell.commentTimeLabel.text!
//            CommentRecipe.commentObjectId = CommentsArray.comments[indexPath.row].commentObjectID
//            CommentRecipe.likeCount = cell.likeCountLabel.text!
//            navigationPushRedirect(storyBoardName: "RecipeDetail", storyBoardId: "Replies")
//        }
