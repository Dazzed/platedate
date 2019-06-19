//
//  SettingsViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 09/05/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import MessageUI
import Parse
import EasyPopUp


class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var dietaryRestrcitionView: UIView!
    @IBOutlet weak var dietaryRestrcitionTableView: UITableView!
    @IBOutlet weak var dietaryRestrcitionImageView: UIImageView!
    @IBOutlet weak var dietaryRestrictionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dietaryAnimationImageView: UIImageView!

    @IBOutlet weak var allergiesView: UIView!
    @IBOutlet weak var allergiesTableView: UITableView!
    @IBOutlet weak var allergiesImageView: UIImageView!
    @IBOutlet weak var allergiesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var allergiesAnimationImageView: UIImageView!

    @IBOutlet weak var measurementTableView: UITableView!
    @IBOutlet weak var measurementImageView: UIImageView!
    @IBOutlet weak var measurementLineImageView: UIImageView!
    @IBOutlet weak var mesurementHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var pushNotificationTableView: UITableView!
    @IBOutlet weak var pushNotificationImageView: UIImageView!
    @IBOutlet weak var pushNotificationHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!
    var popUpConfig = EasyPopupConfig()

    @IBOutlet var signOutPopUPView: UIView!
    @IBOutlet weak var signOutLabel: UILabel!

    var signOutBool:Bool = true

     // Mark: - User Login PopUp
     lazy var signoutPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: signOutPopUPView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        dietaryReuseIdentifier()
        allergiesReuseIdentifier()
        measurementReuseIdentifier()
        pushNotificationReuseIdentifier()
        settingInfo()
        LoadSpinnerView()
    }

    func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
    }

    func settingInfo() {
        spinnerView.isHidden = false
        let user = PFUser.current()!
        Setting.dieatryRestrcitionBool = [false, false, false, false]
        Setting.allergiesBool = [false, false, false, false, false, false, false, false, false]
        Setting.measurentBool = [false, false]
        Setting.pushNotificationBool = [false, false]

        Setting.setDieatryRestrcition = user["dieatryRestriction"] as? Int ?? 0
        Setting.setAllergies = "\(user["allergies"] as? String ?? "0"),"
        Setting.setMeasurent = user["mesurement"] as? String ?? "0"
        Setting.setPushNotification =  "\(user["pushNotification"] as? String ?? "0"),"
        Setting.dieatryRestrcitionBool[Setting.setDieatryRestrcition] = true

        for (i, _) in Setting.allergiesBool.enumerated() {
            if Setting.setAllergies.contains(String(i)) {
                Setting.allergiesBool[i] = true
            }
        }

        Setting.measurentBool[Int(Setting.setMeasurent)!] = true

         for (i, _) in Setting.pushNotificationBool.enumerated() {
            if Setting.setPushNotification.contains(String(i)) {
                Setting.pushNotificationBool[i] = true
            }
        }

        dietaryRestrcitionTableView.reloadData()
        allergiesTableView.reloadData()
        measurementTableView.reloadData()
        pushNotificationTableView.reloadData()
        spinnerView.isHidden = true
    }

    func dietaryReuseIdentifier() {
        dietaryRestrcitionTableView.delegate = self
        dietaryRestrcitionTableView.dataSource = self
        dietaryRestrcitionTableView.register(UINib(nibName: "ProfileDietaryTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDietaryCell")
        dietaryRestrcitionTableView.separatorStyle = .none
        dietaryRestrcitionTableView.backgroundColor = .clear
    }

    func allergiesReuseIdentifier() {
        allergiesTableView.delegate = self
        allergiesTableView.dataSource = self
        allergiesTableView.register(UINib(nibName: "SettingsAllergiesTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsAllergiesCell")
        allergiesTableView.separatorStyle = .none
        allergiesTableView.backgroundColor = .clear
    }

     func measurementReuseIdentifier() {
        measurementTableView.delegate = self
        measurementTableView.dataSource = self
        measurementTableView.register(UINib(nibName: "MeasurementTableViewCell", bundle: nil), forCellReuseIdentifier: "MeasurementCell")
        measurementTableView.separatorStyle = .none
        measurementTableView.backgroundColor = .clear
    }

     func pushNotificationReuseIdentifier() {
        pushNotificationTableView.delegate = self
        pushNotificationTableView.dataSource = self
        pushNotificationTableView.register(UINib(nibName: "PushNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "PushNotificationCell")
        pushNotificationTableView.separatorStyle = .none
        pushNotificationTableView.backgroundColor = .clear
    }

    @IBAction func dietaryRestrictionAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.dietaryRestrictionAnimation()
        })
    }

    func dietaryRestrictionAnimation() {
        if Setting.dieatryAnimationBool == false {
            dietaryAnimationImageView.isHidden = false
            Setting.dieatryAnimationBool = true
            dietaryRestrictionHeightConstraint.constant = 132
        } else {
            Setting.dieatryAnimationBool = false
            dietaryRestrictionHeightConstraint.constant = 0
            dietaryAnimationImageView.isHidden = true
        }
        view.layoutIfNeeded()
    }

    @IBAction func allergiesAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.allergiesAnimation()
        })
    }

    func allergiesAnimation() {
        if Setting.allergiesAnimationBool == false {
            allergiesAnimationImageView.isHidden = false
            Setting.allergiesAnimationBool = true
            allergiesHeightConstraint.constant = 273
        } else {
            allergiesAnimationImageView.isHidden = true
            Setting.allergiesAnimationBool = false
            allergiesHeightConstraint.constant = 0
        }
        view.layoutIfNeeded()
    }

    @IBAction func mesurementAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.mesurementAnimation()
        })
    }

    func mesurementAnimation() {
        if Setting.measurentAnimationBool == false {
            measurementLineImageView.isHidden = false
            Setting.measurentAnimationBool = true
            mesurementHeightConstraint.constant = 77
        } else {
            measurementLineImageView.isHidden = true
            Setting.measurentAnimationBool = false
            mesurementHeightConstraint.constant = 0
        }
        view.layoutIfNeeded()
    }

    @IBAction func pushNotificationAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.pushNotificationAnimation()
        })
    }

    func pushNotificationAnimation() {
        if Setting.pushNotificationAnimationBool == true {
            Setting.pushNotificationAnimationBool = false
            pushNotificationHeightConstraint.constant = 78
        } else {
            Setting.pushNotificationAnimationBool = true
            pushNotificationHeightConstraint.constant = 0
        }
        view.layoutIfNeeded()
    }

     func saveValues() {
        Setting.setAllergies = String(Setting.setAllergies.dropLast())
        Setting.setPushNotification = String(Setting.setPushNotification.dropLast())
        let user = PFUser.current()!
        user["dieatryRestriction"] = Setting.setDieatryRestrcition
        user["allergies"] = Setting.setAllergies
        user["mesurement"] = Setting.setMeasurent
        user["pushNotification"] = Setting.setPushNotification
        user.saveEventually()
    }

    @IBAction func mailButtonAction(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["platedate.info@gmail.com"])
        composeVC.setSubject("Feedback")
        composeVC.setMessageBody("", isHTML: false)

        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["platedate.info@gmail.com"])
        mailComposeVC.setSubject("FeedBack")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    // Mark: - Back Button Action
    @IBAction func rateAppAction(_ sender: Any) {
        rateApp()
    }

    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            UIApplication.shared.openURL(url)
        }
    }

     // Mark: - Back Button Action
    @IBAction func logoutActionAction(_ sender: Any) {
        signOutBool = true
        signOutLabel.text = "Are you sure LOGOUT"
        signOutPopUpAction()

    }

    func signOutPopUpAction() {
        signoutPopUp.config = popUpConfig
         signoutPopUp.showPopup { (isfinished) in
            print(isfinished)
        }
    }


    @IBAction func popUpYesButtonAction(_ sender: Any) {
        if signOutBool == true {
            logout()
        } else {
            deleteUser()
        }
    }

    @IBAction func popUpNoButtonAction(_ sender: Any) {
        signoutPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }



    func logout() {
        Profile.segmentBool = false
        ProfilleRecipeArray.profileRecipeDisplay.removeAll()
        ProfileBookMarkArray.profileBookMark.removeAll()
        self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        self.tabBarController?.tabBar.isHidden = true
        PFUser.logOut()
        UserDefaults.standard.set(false, forKey: "login")
        self.navigationPushRedirect(storyBoardName: "Auth", storyBoardId: "Login")
    }

    @IBAction func DeleteUserAction(_ sender: Any) {
        signOutBool = false
        signOutLabel.text = "Are you sure Delete User"
        signOutPopUpAction()
    }

    func deleteUser() {
        getBookmark()
        removeCollectionRecipe()
        getCollection()
        getLikeCommentUser()
        getComments()
        getrecentlyView()
        getRecipe()
        getReply()
        user()
    }

     func getBookmark() {
        let bookmark = PFQuery(className:"Bookmarks")
        bookmark.whereKey("user", equalTo: PFUser.current()!)
        bookmark.includeKey("user")
        bookmark.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }

    //Mark: - Remove Collection Recipe
    func removeCollectionRecipe() {
        let removeCollectionRecipe = PFQuery(className:"CollectionRecipe")
        removeCollectionRecipe.whereKey("user", equalTo: PFUser.current()!)
        removeCollectionRecipe.includeKey("user")
        removeCollectionRecipe.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }

     //Mark: - Get Collection
    func getCollection() {
        let getCollection = PFQuery(className:"Collections")
        getCollection.whereKey("user", equalTo: PFUser.current()!)
        getCollection.includeKey("user")
          getCollection.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }

     //Mark: - Get Collection
    func getLikeCommentUser() {
         let query = PFQuery(className:"CommentLikes")
         query.whereKey("user", equalTo:PFUser.current()!)
         query.includeKey("user")
         query.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }

      //Mark: - Get Collection
    func getComments() {
         let commentRecipe = PFQuery(className:"Comments")
         commentRecipe.whereKey("userRelationKey", equalTo:PFUser.current()!)
         commentRecipe.includeKey("userRelationKey")
         commentRecipe.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }

     // Mark: - RecentlyViewed
    func getrecentlyView() {
        let recentlyView = PFQuery(className:"RecentlyView")
        recentlyView.whereKey("user", equalTo: PFUser.current()!)
        recentlyView.includeKey("user")
        recentlyView.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }

     // Mark: - RecentlyViewed
    func getRecipe() {
        let query = PFQuery(className:"Recipe")
        query.whereKey("relationKey", equalTo: PFUser.current()!)
        query.includeKey("relationKey")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                 for object in objects! {
                    object.deleteEventually()
                }
            }
        }
    }

    func getReply() {
        let reply = PFQuery(className:"Reply")
        reply.whereKey("relationKey", equalTo: PFUser.current()!)
        reply.includeKey("userRelationKey")
        //CommentsArray.comments.removeAll()
        reply.findObjectsInBackground(block: { (replies: [PFObject]?, error: Error?) in
            if let error = error {
                // There was an error
                print(error.localizedDescription)
            } else {
                for reply in replies! {
                    reply.deleteEventually()
                }
            }
        })
    }

    func user() {
        PFUser.current()?.deleteEventually()
        UserDefaults.standard.set(false, forKey: "login")
        self.navigationPushRedirect(storyBoardName: "Auth", storyBoardId: "Login")
        Profile.segmentBool = false
        ProfilleRecipeArray.profileRecipeDisplay.removeAll()
        ProfileBookMarkArray.profileBookMark.removeAll()
        self.tabBarController?.tabBar.backgroundColor = UIColor.clear
        self.tabBarController?.tabBar.isHidden = true
    }

    // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func aboutPlateDateAction(_ sender: Any) {

    }

    @IBAction func termsButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: "Profile", storyBoardId: "TermsOfService")
    }

    @IBAction func privacyPolicyButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: "Profile", storyBoardId: "PrivacyPolicy")
    }

    @IBAction func communityButtonAction(_ sender: Any) {
        navigationPushRedirect(storyBoardName: "Profile", storyBoardId: "Community")

    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dietaryRestrcitionTableView  {
            return Setting.dieatryRestrcition.count
        } else if tableView == allergiesTableView {
            return Setting.allergies.count
        } else if tableView == measurementTableView {
            return Setting.measurent.count
        } else {
            return Setting.pushNotification.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == dietaryRestrcitionTableView {
            let cell = dietaryRestrcitionTableView.dequeueReusableCell(withIdentifier: "ProfileDietaryCell") as! ProfileDietaryTableViewCell
            cell.dietaryLabel.text = Setting.dieatryRestrcition[indexPath.row]

            if Setting.dieatryRestrcitionBool[indexPath.row] == true {
                cell.radioImageView.image = #imageLiteral(resourceName: "circlePlus")
            } else {
                cell.radioImageView.image = #imageLiteral(resourceName: "Add")
            }
            cell.selectionStyle = .none
            return cell
        } else if  tableView == allergiesTableView {
            let cell = allergiesTableView.dequeueReusableCell(withIdentifier: "SettingsAllergiesCell") as! SettingsAllergiesTableViewCell
            cell.allergiesRestrcitionLabel.text = Setting.allergies[indexPath.row]
            if Setting.allergiesBool[indexPath.row] == true {
                 cell.radioImageView.image = #imageLiteral(resourceName: "circlePlus")
            } else {
                 cell.radioImageView.image = #imageLiteral(resourceName: "Add")
            }
            cell.selectionStyle = .none
            return cell
        } else if tableView == measurementTableView {
            let cell = measurementTableView.dequeueReusableCell(withIdentifier: "MeasurementCell") as! MeasurementTableViewCell
            cell.measurementLabel.text = Setting.measurent[indexPath.row]

            if Setting.measurentBool[indexPath.row] == true {
                cell.radioImageView.image = #imageLiteral(resourceName: "circlePlus")
            } else {
                cell.radioImageView.image = #imageLiteral(resourceName: "Add")
            }
            cell.selectionStyle = .none
            return cell

        } else {
            let cell = pushNotificationTableView.dequeueReusableCell(withIdentifier: "PushNotificationCell") as! PushNotificationTableViewCell

            cell.pushNotificationLabel.text = Setting.pushNotification[indexPath.row]
            if Setting.pushNotificationBool[indexPath.row] == true {
                cell.radioImageView.image = #imageLiteral(resourceName: "circlePlus")
            } else {
                cell.radioImageView.image = #imageLiteral(resourceName: "Add")
            }

            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dietaryRestrcitionTableView {
            let indexPath = dietaryRestrcitionTableView.indexPathForSelectedRow!
            Setting.setDieatryRestrcition = indexPath.row
            unselectDieataryRestriction(index:indexPath.row)
            saveValues()
            dietaryRestrcitionTableView.reloadData()
        } else if tableView == allergiesTableView  {
            let indexPath = allergiesTableView.indexPathForSelectedRow!
            if indexPath.row != Setting.allergiesBool.count - 1 {
                if Setting.allergiesBool[indexPath.row] == true {
                    Setting.allergiesBool[indexPath.row] = false
                    selectAllergies(tag: indexPath.row)
                } else {
                   Setting.allergiesBool[indexPath.row] = true
                   selectAllergies(tag: indexPath.row)
                }
                Setting.allergiesBool[Setting.allergiesBool.count - 1] = false
            } else {
                Setting.allergiesBool.removeAll()
               Setting.setAllergies = "8,"
                Setting.allergiesBool = [false, false, false, false, false, false, false, false, true]
            }

             if Setting.allergiesBool[0] == false   && Setting.allergiesBool[1]  == false  && Setting.allergiesBool[2]  == false && Setting.allergiesBool[3]  == false && Setting.allergiesBool[4]  == false && Setting.allergiesBool[5] == false && Setting.allergiesBool[6]  == false && Setting.allergiesBool[7] == false {
                Setting.allergiesBool[Setting.allergiesBool.count - 1] = true
                selectAllergies(tag: indexPath.row)
                Setting.setAllergies = "8,"
            }
            allergiesTableView.reloadData()
             saveValues()
        } else if tableView == measurementTableView {
            let indexPath = measurementTableView.indexPathForSelectedRow!
            unselectmeasurement(index:indexPath.row)
            Setting.setMeasurent = String(indexPath.row)
            saveValues()
        } else {
            let indexPath = pushNotificationTableView.indexPathForSelectedRow!
            if Setting.pushNotificationBool[indexPath.row] == false {
                Setting.pushNotificationBool[indexPath.row] = true
                Setting.setPushNotification = "\(Setting.setPushNotification + "\(String(indexPath.row))"),"
            } else {
                Setting.pushNotificationBool[indexPath.row] = false
                Setting.setPushNotification = Setting.setPushNotification.replacingOccurrences(of:"\(String(indexPath.row)),", with: "", options: .literal, range: nil)
            }
            pushNotificationTableView.reloadData()
            saveValues()
        }

        print("ALLLLLLLTTTTTiIIIImmwmmw workdfgwdbf")
    }

    func unselectDieataryRestriction(index:Int) {
        for (i,_) in Setting.dieatryRestrcitionBool.enumerated() {
            if index == i {
                Setting.dieatryRestrcitionBool[i] = true
            } else {
               Setting.dieatryRestrcitionBool[i] = false
            }
        }
        dietaryRestrcitionTableView.reloadData()
    }

     func selectAllergies(tag:Int) {
        for (i,_) in Setting.allergies.enumerated() {
            if i == tag {
                if Setting.allergiesBool[i] == true {
                    Setting.setAllergies = Setting.setAllergies.replacingOccurrences(of:"8,", with: "", options: .literal, range: nil)
                    Setting.setAllergies = Setting.setAllergies.replacingOccurrences(of:"8", with: "", options: .literal, range: nil)
                    Setting.setAllergies = "\(Setting.setAllergies + "\(i)"),"
                } else {
                    Setting.setAllergies = Setting.setAllergies.replacingOccurrences(of:"\(i),", with: "", options: .literal, range: nil)
                }
            }
        }
    }

     func unselectmeasurement(index:Int) {
        for (i,_) in Setting.measurentBool.enumerated() {
            if index == i {
                Setting.measurentBool[i] = true
            } else {
                Setting.measurentBool[i] = false
            }
        }
        measurementTableView.reloadData()
    }
}
