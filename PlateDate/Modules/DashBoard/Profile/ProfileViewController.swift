//
//  ProfileViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 07/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//




import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet var segmentTitle: ScrollableSegmentedControl!
    @IBOutlet weak var recipesView: UIView!
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var bookMarkTableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var recipeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayRecipesView: UIView!
    @IBOutlet weak var recipeTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookMarkTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowImageConstraint: NSLayoutConstraint!

    @IBOutlet weak var recipeViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookMarkViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookMarkViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var linkViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentTopViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var spinnerView: UIView!

    @IBOutlet weak var spinnerInsiedView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    var recipeshadowHeight:CGFloat = 0
    var bookMarkshadowHeight:CGFloat = 0

    // Mark: - Declaration
    let screenSize = UIScreen.main.bounds
    var following = 0
    var followers = 0
    var myMutableString = NSMutableAttributedString()
    var contentSizeHeight:CGFloat = 0.0
    var bookMarkHeight:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        swipeTableView()
        profileRecipeReuseIdentifier()
        profileBookMarkReuseIdentifier()
        displayRecipesView.addTopBorderWithColor(color: UIColor._bottomBorderGray, width: 1.0, view: displayRecipesView)
       // getBookmark()

        profileView.backgroundColor = .clear
        bookmarkView.backgroundColor = .clear
        LoadSpinnerView()
       //
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfo()
        self.recipeTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.bookMarkTableView.addObserver(self, forKeyPath: "bookMarkTableView", options: .new, context: nil)
        if Profile.segmentBool == true {
           //setUpSegment()
        }
        getBookmark()
        self.tabBarController?.tabBar.isHidden = false
    }

    func LoadSpinnerView() {
        spinnerInsiedView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerInsiedView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize") {
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                contentSizeHeight = newsize.height
            }
        }

        if(keyPath == "bookMarkTableView"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                bookMarkHeight = newsize.height
                print("bookMarkHeightbookMarkHeight\(bookMarkHeight)")
            }
        }
    }

     override func viewWillDisappear(_ animated: Bool) {
        self.recipeTableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }

     // Mark: - Trending
    func profileRecipeReuseIdentifier() {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.register(UINib(nibName: "ProfileRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileRecipeCell")
        recipeTableView.separatorStyle = .none
        recipeTableView.backgroundColor = .clear
        recipeTableView.contentInset.bottom = 23
      //  recipeTableView.estimatedRowHeight = 311
    }

     // Mark: - Following
    func profileBookMarkReuseIdentifier() {
        bookMarkTableView.delegate = self
        bookMarkTableView.dataSource = self
        bookMarkTableView.register(UINib(nibName: "ProfileBookMarkTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileBookMarkCell")
        bookMarkTableView.separatorStyle = .none
        bookMarkTableView.backgroundColor = .clear
        bookMarkTableView.contentInset.bottom = 23
    }

    func userInfo() {
        let user = PFUser.current()!
        let loadImageParams = LoadImageParams(showActivityIndicator: false)
        profileNameLabel.text = user["profileName"] as? String
        usernameLabel.text = user["userDisplayName"] as? String

        if user["profileImage"] == nil {
            if user["profilePicture"] == nil {
                profileImageView.image = #imageLiteral(resourceName: "Profile")
            } else {
                profileImageView.loadImage(fromUrl: user["profilePicture"]  as? String, withParams: loadImageParams, completion: nil)
            }
        } else {
            let profileImageFile = user["profileImage"] as? PFFileObject
            profileImageView.loadImage(fromUrl: profileImageFile?.url, withParams: loadImageParams, completion: nil)
        }

        //following = user["following"] as! Int
        //followers = user["followers"] as! Int

        if user["location"] == nil && user["link"] != nil {
            segmentTopViewHeightConstraint.constant = -20
        }

        if user["location"] == nil {
            locationViewHeightConstraint.constant = 0
            locationView.isHidden = true
        } else {
             locationLabel.text = user["location"] as? String
        }

        if user["bio"] == nil {
            userBioLabel.text = ""
             segmentTopViewHeightConstraint.constant = -20
        } else {
            userBioLabel.text = user["bio"] as? String
        }

        if user["link"] == nil {
            linkViewHeightConstraint.constant = 0
            segmentTopViewHeightConstraint.constant = 0
            linkView.isHidden = true
        } else {
            linkLabel.text = user["link"] as? String
        }
        followingCount()
    }

    func followingCount() {
        followingCountLabel.text = "\(followers) followers  |  \(following) following"
        followingCountLabel.changeFont(ofText: "10", with: UIFont(name: "SourceSansPro-Bold", size: 12.0) ?? UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.semibold))
        followingCountLabel.changeFont(ofText: "|", with: UIFont(name: "SourceSansPro-Bold", size: 12.0) ?? UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.semibold))
        followingCountLabel.changeFont(ofText: "15", with: UIFont(name: "SourceSansPro-Bold", size: 12.0) ?? UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.semibold))
    }

      // Mark: - SetUp Segment
    func setUpSegment() {
        if Profile.segmentBool == true {
            segmentTitle.updateSegemnt(index: 0, value: "\(ProfilleRecipeArray.profileRecipeDisplay.count) Recipes")
            segmentTitle.updateSegemnt(index: 1, value: "\(ProfileBookMarkArray.profileBookMark.count) Bookmarks")
        } else {
            segmentTitle.segmentStyle = .textOnly
            segmentTitle.insertSegment(withTitle: "\(ProfilleRecipeArray.profileRecipeDisplay.count) Recipes", image: nil, at: 0)
            segmentTitle.insertSegment(withTitle: "\(ProfileBookMarkArray.profileBookMark.count) Bookmarks", image: nil, at: 1)
        }

        if Profile.segmentIndex == 0 {
            recipeTableView.reloadData()
            recipeViewAnimation()
        } else if Profile.segmentIndex == 1 {
           // bookMarkTableView.reloadData()
            bookmarkViewAnimation()
        }
        segmentTitle.underlineSelected = true
        segmentTitle.selectedSegmentIndex = Profile.segmentIndex
        segmentTitle.fixedSegmentWidth = true
        segmentTitle.tintColor = UIColor._lightningYellow
        segmentTitle.addTarget(self, action: #selector(ProfileViewController.segmentSelected(sender:)), for: .valueChanged)
        Profile.segmentBool = true
        spinnerView.isHidden = true
    }

     // Mark: - Swipe Gesture Action
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                recipeViewAnimation()
                segmentTitle.selectedSegmentIndex = 0
            case UISwipeGestureRecognizerDirection.left:
                 bookmarkViewAnimation()
                segmentTitle.selectedSegmentIndex = 1
            default:
                print("sdsd")
            }
        }
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

    // Mark: - Segment Selected
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            recipeTableView.reloadData()
            Profile.segmentIndex = 0
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.recipeViewAnimation()
                })
        } else {
            Profile.segmentIndex = 1
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.bookMarkTableView.reloadData()
                self.bookmarkViewAnimation()
            })
        }
    }

    func recipeViewAnimation() {
        self.recipeViewLeadingConstraint.constant = 0
        self.recipeViewTrailingConstraint.constant = 0
        self.bookMarkViewLeadingConstraint.constant = self.screenSize.width
        self.bookMarkViewTrailingConstraint.constant = -self.screenSize.width
        self.view.layoutIfNeeded()
        shadowImageConstraint.constant = recipeTableView.contentSize.height + 15
        view.layoutIfNeeded()
    }

    func bookmarkViewAnimation() {
        self.recipeViewLeadingConstraint.constant = -self.screenSize.width
        self.recipeViewTrailingConstraint.constant = self.screenSize.width
        self.bookMarkViewLeadingConstraint.constant = 0
        self.bookMarkViewTrailingConstraint.constant = 0
        self.view.layoutIfNeeded()
        shadowImageConstraint.constant = bookMarkTableView.contentSize.height + 15
    }

    // Mark: - Display All Recipe
    func profileDisplayRecipes() {
        let query = PFQuery(className:"Recipe")
        query.includeKey("relationKey")
        query.whereKey("relationKey", equalTo: PFUser.current()!)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground(block: { (recipes: [PFObject]?, error: Error?) in
            if let error = error {
                // There was an error
                print("error.localizedDescription\(error.localizedDescription)")
            } else {
                ProfilleRecipeArray.profileRecipeDisplay.removeAll()
                for recipe in recipes! {
                      let user:PFUser = recipe["relationKey"] as! PFUser
                        var recipeImageUrl:String = ""
                        if recipe["recipeImage"] == nil {
                        recipeImageUrl = ""
                    } else {
                        let recipeImageFile = recipe["recipeImage"] as? PFFileObject
                        recipeImageUrl = recipeImageFile?.url ?? ""
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

                ProfilleRecipeArray.profileRecipeDisplay.append(ProfileRecipe(recipeObjectId: recipe.objectId!, recipeTitle:  recipe["recipeTitle"] as! String, recipeDescription: recipe["recipeDescription"] as! String, recipeCreateTime: String(describing: recipe.createdAt?.toLocalTime()), recipeImageUrl: recipeImageUrl, recipeUserName: user["userDisplayName"] as! String, bookMark: DashBoardArray.bookMarkString, recipeUserobjectId: user.objectId!, recipeMode: recipe["recipeMode"] as! String, recipeUserImageUrl: recipeUserImageUrl))

                }
                self.setUpSegment()
            }
        })
    }

    // Mark : Get User BookMarks
    func getBookmark() {
        spinnerView.isHidden = false
        let bookmark = PFQuery(className:"Bookmarks")
        bookmark.whereKey("user", equalTo: PFUser.current()!)
        bookmark.includeKey("relationKey")
        bookmark.includeKey("user")
        bookmark.includeKey("relationKey.relationKey")
        bookmark.order(byDescending: "createdAt")
        bookmark.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 ProfileBookMarkArray.profileBookMark.removeAll()
                 for object in objects! {
                    let recipe:PFObject = object["relationKey"] as! PFObject
                    //recipe.includeKey("relationKey")
                    let recipeImageFile = recipe["recipeImage"] as! PFFileObject
                    let user:PFUser = recipe["relationKey"] as! PFUser
                   // let user:PFUser = object["relationKey"] as! PFUser

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
                    

                    ProfileBookMarkArray.profileBookMark.append(ProfileBookMark(recipeObjectId: recipe.objectId!, recipeTitle:  recipe["recipeTitle"] as! String, recipeDescription: recipe["recipeDescription"] as! String,  recipeCreateTime: String(describing: recipe.createdAt?.toLocalTime()), recipeImageUrl:recipeImageFile.url ?? "", recipeUserName: user["userDisplayName"] as! String, bookMark: DashBoardArray.bookMarkString, recipeUserobjectId: user.objectId!, recipeUserImageUrl: recipeUserImageUrl))

                }
                //self.bookMarkTableView.reloadData()
                self.profileDisplayRecipes()
            }
        }
    }

    @IBAction func editButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: "Profile", storyBoardId: "EditProfile")
    }

     @IBAction func settingsButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: "Profile", storyBoardId: "Settings")
    }

    @IBAction func notificationButtonAction(_ sender: Any) {
         navigationPushRedirect(storyBoardName: "Profile", storyBoardId: "OtherUser")

    }


}

extension ProfileViewController:  UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recipeTableView {
            print("ProfilleRecipeArray.profileRecipeDisplay.count\(ProfilleRecipeArray.profileRecipeDisplay.count)")
            return ProfilleRecipeArray.profileRecipeDisplay.count
        } else {
            print("ProfileBookMarkArray.profileBookMark.count\(ProfileBookMarkArray.profileBookMark.count)")
            return ProfileBookMarkArray.profileBookMark.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recipeTableView {
            let cell = recipeTableView.dequeueReusableCell(withIdentifier:  "ProfileRecipeCell") as! ProfileRecipeTableViewCell
            cell.recipeTitleLabel.text = ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].recipeTitle
            cell.recipeDescriptionLabel.text = ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].recipeDescription
            cell.recipeUserNameLabel.text = ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].recipeUserName
            cell.recipeTimeLabel.text = currentTime(time: ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].recipeCreateTime).uppercased()
            let loadImageParams = LoadImageParams(showActivityIndicator: false)

            if User.userProfileImage != nil {
                cell.recipeUserImageView.image = User.userProfileImage
            } else {
                cell.recipeUserImageView.image = nil
            }


            if ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].recipeImageUrl != "" {
                cell.profileRecipeImageView.loadImage(fromUrl: ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].recipeImageUrl, withParams: loadImageParams, completion: nil)
            } else {
                cell.profileRecipeImageView.image = #imageLiteral(resourceName: "spash_bg")
            }

            cell.recipeBookMarkButton.tag = indexPath.row
            //cell.recipeBookMarkButton.addTarget(self, action: #selector(bookMarkButtonAction), for: .touchUpInside)

            if ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].bookMark == "1" {
                cell.recipeBookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark orange.png"), for: .normal)
            } else {
                 cell.recipeBookMarkButton.setImage(#imageLiteral(resourceName: "Bookmark grey.png"), for: .normal)
            }

           // recipeTableViewHeightConstraint.constant = contentSizeHeight + 15
           // recipeViewHeightConstraint.constant = contentSizeHeight + 15

           if Profile.segmentIndex == 0 {
                print("recipeTableviewcontentSizeHeight\(recipeTableView.contentSize.height)")
            //    shadowImageConstraint.constant = recipeTableView.contentSize.height + 15
             //   recipeshadowHeight = contentSizeHeight + 15
           }

            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        } else {

            let cell = bookMarkTableView.dequeueReusableCell(withIdentifier:  "ProfileBookMarkCell") as! ProfileBookMarkTableViewCell

            cell.recipeTitleLabel.text = ProfileBookMarkArray.profileBookMark[indexPath.row].recipeTitle
            cell.recipeDescriptionLabel.text = ProfileBookMarkArray.profileBookMark[indexPath.row].recipeDescription
            cell.recipeUserNameLabel.text = ProfileBookMarkArray.profileBookMark[indexPath.row].recipeUserName


            cell.recipeTimeLabel.text = currentTime(time: ProfileBookMarkArray.profileBookMark[indexPath.row].recipeCreateTime).uppercased()
            let loadImageParams = LoadImageParams(showActivityIndicator: false)


            print("ProfileBookMarkArray.profileBookMark[indexPath.row].recipeUserImageUrl\(ProfileBookMarkArray.profileBookMark[indexPath.row].recipeUserImageUrl)")

            //cell.profileBookMarkImageView.loadImage(fromUrl: ProfileBookMarkArray.profileBookMark[indexPath.row].recipeUserImageUrl, withParams: loadImageParams, completion: nil)

            if ProfileBookMarkArray.profileBookMark[indexPath.row].recipeImageUrl != "" {
                cell.profileBookMarkImageView.loadImage(fromUrl: ProfileBookMarkArray.profileBookMark[indexPath.row].recipeImageUrl, withParams: loadImageParams, completion: nil)
            } else {
                cell.profileBookMarkImageView.image = #imageLiteral(resourceName: "spash_bg")
            }

            cell.recipeUserImageView.loadImage(fromUrl: ProfileBookMarkArray.profileBookMark[indexPath.row].recipeUserImageUrl, withParams: loadImageParams, completion: nil)

            cell.recipeBookMarkButton.tag = indexPath.row
            cell.recipeBookMarkButton.addTarget(self, action: #selector(bookMarkRemoveButtonAction), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            shadowImageConstraint.constant = bookMarkTableView.contentSize.height + 15
           bookMarkshadowHeight = bookMarkTableView.contentSize.height + 15

            return cell
        }
    }

    @objc func bookMarkRemoveButtonAction(sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: bookMarkTableView)
        let indexPath = bookMarkTableView.indexPathForRow(at: buttonPosition)!
        DashBoardArray.removeBookMark = ProfileBookMarkArray.profileBookMark[indexPath.row].recipeObjectId
       ProfileBookMarkArray.profileBookMark.remove(at: indexPath.row)
       bookMarkTableView.reloadData()
       setUpSegment()
       removeBookMark()
       bookmarkViewAnimation()
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

            }
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
                print("success")
                Profile.bookMarkBool = true
            }
            else {
                print(error?.localizedDescription ?? "Server Error")
        }})
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == recipeTableView {
            let indexPath = recipeTableView.indexPathForSelectedRow!
            //let cell = recipeTableView.cellForRow(at: indexPath) as! ProfileRecipeTableViewCell

            if ProfilleRecipeArray.profileRecipeDisplay[indexPath.row].recipeMode == "0" {
                RecipeDetail.recipeObjectId = ProfilleRecipeArray.profileRecipeDisplay[(indexPath.row)].recipeObjectId
                RecipeDetail.recipeUserObjectId = ProfilleRecipeArray.profileRecipeDisplay[(indexPath.row)].recipeUserobjectId
                navigationPushRedirect(storyBoardName:  ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
            } else {
                getRecipe.recipeObjectId = ProfilleRecipeArray.profileRecipeDisplay[(indexPath.row)].recipeObjectId
                navigationPushRedirect(storyBoardName: "AddRecipe", storyBoardId: "EditRecipe")
            }
        } else {
             let indexPath = bookMarkTableView.indexPathForSelectedRow!
             RecipeDetail.recipeObjectId = ProfileBookMarkArray.profileBookMark[(indexPath.row)].recipeObjectId
              RecipeDetail.recipeUserObjectId = ProfileBookMarkArray.profileBookMark[(indexPath.row)].recipeUserobjectId
              navigationPushRedirect(storyBoardName:  ViewController.StroyBoardName.recipeDetail, storyBoardId: ViewController.StoryBoardId.recipeDetailStoryBoardId)
        }
    }
}
