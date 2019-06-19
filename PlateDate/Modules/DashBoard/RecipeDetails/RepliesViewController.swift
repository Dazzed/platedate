//
//  RepliesViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 02/04/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift

class RepliesViewController: UIViewController {

    @IBOutlet weak var replyTextView: UIView!
    @IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var commentNameLabel: UILabel!
    @IBOutlet weak var repliesRatingView: FloatRatingView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTimingLabel: UILabel!
    @IBOutlet weak var replyTableView: UITableView!
    @IBOutlet weak var replyUserImageView: UIImageView!
    //@IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var tableViewHeightConstrint: NSLayoutConstraint!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var repliesButton: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!

    @IBOutlet weak var replyView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        RecipeDetail.commentsBool = true
        diplayComment()
        replyReuseIdentifier()
        if ReplyArray.reply.count == 0 {
            tableViewHeightConstrint.constant = 1
        }

        if PFUser.current()?.objectId == nil {
            replyView.isHidden = true
        }
        //hideKeyboardWhenTappedAround()
        getReply()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: Notification.Name.UIKeyboardWillShow, object: nil)

         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideFrame), name: Notification.Name.UIKeyboardWillHide, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)

        let loadImageParams = LoadImageParams(showActivityIndicator: false)
        userProfileImageView.loadImage(fromUrl:User.userProfileImageUrl, withParams: loadImageParams, completion: nil)

       // IQKeyboardManager.shared.enable = false
    }

    //Calls this function when the tap is recognized.
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    // test if our control subview is on-screen
        if repliesButton.superview != nil {
            if touch.view?.isDescendant(of: repliesButton) ?? false {
                // we touched our control surface
                return true // ignore the touch
            }
        }
        return true // handle the touch
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.tabBarController?.tabBar.isHidden = true
        replyTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old, .prior], context: nil)
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        IQKeyboardManager.shared.enable = false
    }

    var replyTableViewContentSizeHeight:CGFloat = 0.0

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                replyTableViewContentSizeHeight = newsize.height
            }
            tableViewHeightConstrint.constant =  replyTableViewContentSizeHeight + 30
        }
    }

     @objc private func keyboardWillChangeFrame(_ notification: Notification) {
       // if let endFrame = notification.userInfo?[UIResponder.key]
        let info = notification.userInfo
        let endFrame = info?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let newFrame = endFrame?.cgRectValue
        var keyboardHeight = UIScreen.main.bounds.height - (newFrame?.origin.y)!
        if keyboardHeight > 0 {
            keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
        }

        textViewBottomConstaint.constant = -keyboardHeight + 8
        // textViewBottomConstaint.constant = -500
        view.layoutIfNeeded()
    }

    @objc private func keyboardWillHideFrame(_ notification: Notification) {
       // if let endFrame = notification.userInfo?[UIResponder.key]
        textViewBottomConstaint.constant = 0
        view.layoutIfNeeded()
    }




    func getReply() {
        let reply = PFQuery(className:"Reply")
        reply.whereKey("commentObjectId", equalTo: CommentRecipe.commentObjectId)
        reply.includeKey("userRelationKey")
        //CommentsArray.comments.removeAll()
        ReplyArray.reply.removeAll()
        reply.findObjectsInBackground(block: { (replies: [PFObject]?, error: Error?) in
            if let error = error {
                // There was an error
                print(error.localizedDescription)
            } else {
                for reply in replies! {
                    let user:PFUser = reply["userRelationKey"] as! PFUser

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

                    print("user[userDisplayNam] as! String\(user["userDisplayName"] as! String)")
                    print("recipeUserImageUrl\(recipeUserImageUrl)")


                    ReplyArray.reply.append(Reply(userName: user["userDisplayName"] as! String, reply: reply["reply"] as! String, replyTime: String(describing: reply.createdAt?.toLocalTime()), likeCount: 0, replyUserImageUrl: recipeUserImageUrl))
                }
                self.replyTableView.reloadData()
            }
        })
    }

     // Mark: - Reply Reuse Identifier
     func replyReuseIdentifier() {
        replyTableView.delegate = self
        replyTableView.dataSource = self
        replyTableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier:  "ReplyCell")
        replyTableView.backgroundColor = UIColor.clear
        replyTableView.separatorColor = UIColor._lightGraySeparator
        replyTableView.rowHeight = UITableViewAutomaticDimension
        replyTableView.reloadData()
    }

    func diplayComment() {
        commentNameLabel.text = CommentRecipe.commentUserName
        repliesRatingView.rating = CommentRecipe.repliesRatingView
        if CommentRecipe.imageBool == true {
            commentImageView.image = CommentRecipe.commentImage
            commentImageViewHeightConstraint.constant = 264
        } else {
            commentImageViewHeightConstraint.constant = 0
        }
        commentLabel.text = CommentRecipe.comment
        commentTimingLabel.text = CommentRecipe.commentTimingLabel
        likeCountLabel.text = CommentRecipe.likeCount
        replyUserImageView.image = CommentRecipe.commentUserImage
    }

     // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func doneAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func postButtonAction(_ sender: Any) {
         let user = PFUser.current()!
        if replyTextField.text == "" {
            alert(title: "Error!", message: "please Enter your reply", cancel: "Cancel")
        } else {
            ReplyArray.reply.append(Reply(userName: user["userDisplayName"] as! String, reply: replyTextField.text!, replyTime: "Just Now", likeCount: 0, replyUserImageUrl:  User.userProfileImageUrl))
        }
        self.replyTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old, .prior], context: nil)
        replyTableView.reloadData()


        addReply() 
    }

     // Mark: - Add reply
    func addReply() {
        let reply = PFObject(className:"Reply")
        let user = PFUser.current()
        reply["reply"] = replyTextField.text!
        reply["replyCount"] = 0
        reply["commentObjectId"] = CommentRecipe.commentObjectId
        reply["comment"] = PFObject(withoutDataWithClassName:"Comments",  objectId:(CommentRecipe.commentObjectId))
        reply["userRelationKey"] = user
        reply["userRelationKey"] = PFUser(withoutDataWithClassName:"_User", objectId:(PFUser.current()?.objectId!))
         reply.saveInBackground(block: { (success, error) in
            if error == nil {
                print("success")
                self.replyCountAPI()
            }
            else {
                print(error?.localizedDescription ?? "Server Error")
        }})
    }

    func replyCountAPI() {
        let query = PFQuery(className:"Reply")
        query.whereKey("commentObjectId", equalTo:CommentRecipe.commentObjectId)
        query.limit = 1
        query.countObjectsInBackground { (count: Int32, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Sean has played \(count) games")
                replyCountArray.reply.append(replyCountObject(commentObjectId: CommentRecipe.commentObjectId, count: Int(count)))
            }
        }
    }
}

extension RepliesViewController: UITableViewDelegate, UITableViewDataSource {

    //MARK: - TableView data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //MARK: - Hide CookWare TableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int   {
        return ReplyArray.reply.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = replyTableView.dequeueReusableCell(withIdentifier:"ReplyCell") as! ReplyTableViewCell
         cell.selectionStyle = .none
         cell.replyUsernameLabel.text = ReplyArray.reply[indexPath.row].userName
         cell.replyLabel.text = ReplyArray.reply[indexPath.row].reply
        let loadImageParams = LoadImageParams(showActivityIndicator: false)
        cell.replyUserImageView.loadImage(fromUrl:ReplyArray.reply[indexPath.row].replyUserImageUrl, withParams: loadImageParams, completion: nil)

         if String(ReplyArray.reply[indexPath.row].replyTime) == "Just Now" {
            cell.replyTimeLabel.text = "Just Now"
        } else {
            cell.replyTimeLabel.text = currentTime(time: ReplyArray.reply[indexPath.row].replyTime).uppercased()
        }

         cell.likeCountLabel.text = String(ReplyArray.reply[indexPath.row].likeCount)

         return cell
    }
}

