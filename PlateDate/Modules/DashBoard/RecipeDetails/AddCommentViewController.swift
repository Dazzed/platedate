//
//  AddCommentViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 29/03/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import ImagePicker
import Parse

class AddCommentViewController: UIViewController,ImagePickerDelegate, UITextViewDelegate {

    // Mark: - @IBOutlets
    @IBOutlet var commentImageView: UIImageView!
    @IBOutlet var imageRemoveButton: UIButton!
    @IBOutlet var imageIconView: UIView!
    @IBOutlet weak var imagePicButton: UIButton!
    @IBOutlet weak var addCommentTextView: UITextView!
    @IBOutlet weak var ratingRecipe: FloatRatingView!
    @IBOutlet weak var characterCountLabel: UILabel!
    var rating:Double = 0.0


    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        RecipeDetail.commentsBool = true 
        addCommentTextView.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        LoadSpinnerView()
        // Do any additional setup after loading the view.
    }

    func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    //Mark: - Get image from Gallery
    @IBAction func imgaePickerButtonAction(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }

    //Mark: - Recipe Image Remove
    @IBAction func imageRemoveButtonAction(_ sender: Any) {
        imageRemoveButton.isHidden = true
        commentImageView.image = nil
        imageIconView.isHidden = false
        imagePicButton.isHidden = false 
    }

    @IBAction func submitButtonAction(_ sender: Any) {
       if addCommentTextView.text == "" {
            alert(title: "Error!", message: "Please enter your comment", cancel: "cancel")
        } else {
            addComment()
        }
    }

    func addComment() {
        spinnerView.isHidden = false
        let user = PFUser.current()
        let addComment = PFObject(className:"Comments")
        let recipe = PFObject(className:"Recipe")

        addComment["userRelationKey"] = user
        addComment["userRelationKey"] = PFUser(withoutDataWithClassName:"_User", objectId:(PFUser.current()?.objectId!))

        addComment["recipeRelationKey"] = recipe
        addComment["recipeRelationKey"] = PFObject(withoutDataWithClassName:"Recipe",  objectId:RecipeDetail.recipeObjectId)
        rating = ratingRecipe.rating
        addComment["rating"] = rating
        addComment["comment"] = addCommentTextView.text!.trimmingCharacters(in: .whitespaces)
        addComment["likesCount"] = 0
        addComment["recipeId"] = RecipeDetail.recipeObjectId
        addComment["replyCount"] = 0

         //Mark : - Save Image
        if commentImageView.image != nil {
            let imageData = UIImageJPEGRepresentation(commentImageView.image!, 0.5)
            let imageFile = PFFileObject(name:"avatar.jpg", data:imageData!)
            addComment["commentImage"] = imageFile
        } else {
            
        }

         //Mark : - Upload Recipe
        addComment.saveInBackground(block: { (success, error) in
            if error == nil {
                 self.alert(title: "Congratulations", message: "Your comment has been submitted.", cancel: "Ok")
                 self.removeComment()
                 self.getComments()
                 self.spinnerView.isHidden = true
           } else {
                print("Failed")
                self.spinnerView.isHidden = true
        }})
    }

    func removeComment() {
        addCommentTextView.text = ""
        ratingRecipe.rating = 0
        imageRemoveButton.isHidden = true
        commentImageView.image = nil
        imageIconView.isHidden = false
        imagePicButton.isHidden = false
    }

    func  getComments(){
        let commentRecipe = PFQuery(className:"Comments")
        commentRecipe.whereKey("recipeId", equalTo: RecipeDetail.recipeObjectId)
        commentRecipe.limit = 1
        commentRecipe.order(byDescending: "createdAt")
        commentRecipe.includeKey("userRelationKey")
        commentRecipe.findObjectsInBackground(block: { (comments: [PFObject]?, error: Error?) in
            if let error = error {
                // There was an error
                print(error.localizedDescription)
            } else {
                for comment in comments! {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                      let user:PFUser = comment["userRelationKey"] as! PFUser
                      var commentImageFile:PFFileObject!
                       if comment["commentImage"] != nil {
                        commentImageFile = comment["commentImage"] as? PFFileObject
                        CommentsArray.comments.insert((Comments(profileImageUrl: "", username: user["userDisplayName"] as! String, rating: comment["rating"] as! Double, commentImageUrl: commentImageFile.url!, comment: comment["comment"] as! String, time: String(describing:  comment.createdAt), replyCount:0, likeCount: comment["likesCount"] as! Int, commentObjectID: comment.objectId!, likeCommentBool: false, userObjectId: user.objectId!, commentUserImageUrl: User.userProfileImageUrl)), at: 0)
                        } else {
                        CommentsArray.comments.insert((Comments(profileImageUrl: "", username:  user["userDisplayName"] as! String, rating: comment["rating"] as! Double, commentImageUrl: "", comment: comment["comment"] as! String, time: String(describing: comment.createdAt), replyCount: 0, likeCount: comment["likesCount"] as! Int, commentObjectID: comment.objectId!, likeCommentBool: false, userObjectId: user.objectId!, commentUserImageUrl: User.userProfileImageUrl)), at: 0)
                        }
                    }

                }
            }
        })
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == addCommentTextView {
            characterCountLabel.text = String("\(textView.text.count)/300 characters")
        }
    }

     //Mark: - TextView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == addCommentTextView {
            if range.location == 0 {
                let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            } else {
                if(textView.text.count > 299) {
                    print("Please summarize in 300 characters or less")
                    return false
                }
            }
        }
         return true
    }

      // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddCommentViewController {

    //Mark: - ImagePicker Delegate Methods
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {

    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count != 0 {
            commentImageView.image = images[0]
            imageRemoveButton.isHidden = false
            imageIconView.isHidden = true
            imagePicButton.isHidden = true
            self.dismiss(animated: true, completion: nil)
            let bundle = Bundle(for: AssetManager.self)
            print(bundle.resourcePath ?? "sdfdsf")
          //  var webData: Data? = UIImagePNGRepresentation(recipeImageView.image!)
            var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            AddRecipe.filePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("png").absoluteString
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}
