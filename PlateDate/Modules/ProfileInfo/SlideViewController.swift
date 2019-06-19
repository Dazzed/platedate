//
//  SlideViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 07/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Parse

class SlideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // Mark: - @IBOutlets
    @IBOutlet var slideView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var pageControlBottomConstaint: NSLayoutConstraint!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!
    
    // Mark: - @Declaration
    var callNameView = CallNameView()
    var userNameView = UserNameView()
    var dieataryRestrictionView = DietaryRestrictionsView()
    var allergiesView = AllergiesView()
    var currentView:CGFloat = 0
    var allergiesArray = ["Dairy", "Egg", "Gluten", "Peanut", "Tree Nut", "Seafood", "Sesame", "Soy", "None"]
    var dietaryRestrictionsArray = ["Vegetarian", "Pescetarian", "Vegan", "None" ]
    var allergiesBoolArray = [false, false, false, false, false, false, false, false, true]
    var dietaryRestrictionsBoolArray = [false, false, false, true]
    var allergiesString = "8,"

     override func viewDidLoad() {
        super.viewDidLoad()
        loadCallNameView()
        loadUserNameView()
        loadDieataryRestrictionView()
        loadAllergiesView()
        reuseIdentifier()
        keyBoardHeight()
        // Mark: - PageControl Dot size Increase
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        LoadSpinnerView()
    }

     func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
        spinnerView.isHidden = true
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // Mark: - Load CallNameView
    func loadCallNameView() {
        callNameView = (Bundle.main.loadNibNamed(XibName.callNameView, owner: self, options: nil)?.first as? CallNameView)!
        callNameView.frame = CGRect(x: 0,y: 0, width:slideView.frame.width , height:slideView.frame.height)
        callNameView.callNameTextField.becomeFirstResponder()
        callNameView.callNameTextField.delegate = self
        slideView.addSubview(callNameView)
       // backButton.isHidden = true
    }

    // Mark: - Load UserNameView
    func loadUserNameView() {
        userNameView = (Bundle.main.loadNibNamed(XibName.userNameView, owner: self, options: nil)?.first as? UserNameView)!
        //backButton.isHidden = true
        userNameView.frame = CGRect(x: 1 * slideView.frame.width ,y: 0, width:slideView.frame.width, height:slideView.frame.height)
        userNameView.userNameTextField.delegate = self
        slideView.addSubview(userNameView)
    }

    // Mark: - Load DieataryRestrictionView
    func loadDieataryRestrictionView() {
        dieataryRestrictionView = (Bundle.main.loadNibNamed(XibName.dieatrayRestrictionView, owner: self, options: nil)?.first as? DietaryRestrictionsView)!
       // backButton.isHidden = false
        dieataryRestrictionView.frame = CGRect(x: 2 * slideView.frame.width ,y: 0, width:slideView.frame.width, height:slideView.frame.height)
        slideView.addSubview(dieataryRestrictionView)
    }

    // Mark: - Load AllergiesView
    func loadAllergiesView() {
         allergiesView = (Bundle.main.loadNibNamed(XibName.allergiesView, owner: self, options: nil)?.first as? AllergiesView)!
        allergiesView.frame = CGRect(x: 3 * slideView.frame.width ,y: 0, width:slideView.frame.width, height:slideView.frame.height)
        slideView.addSubview(allergiesView)
        //backButton.isHidden = false
    }

    // Mark: - ReuseIdentifier
    func reuseIdentifier() {
        dieataryRestrictionView.dietaryTableView.register(UINib(nibName: TableViewCell.ClassName.dieatary, bundle: nil), forCellReuseIdentifier: TableViewCell.ReuseIdentifier.dieatary)
        dieataryRestrictionView.dietaryTableView.separatorStyle = .none
       //dieataryRestrictionView.dietaryTableView.reloadData()

        allergiesView.allergiesTableView.register(UINib(nibName: TableViewCell.ClassName.allergies, bundle: nil), forCellReuseIdentifier: TableViewCell.ReuseIdentifier.allergies)
        allergiesView.allergiesTableView.separatorStyle = .none

         // Mark: - Delegate & Datasource
        dieataryRestrictionView.dietaryTableView.delegate = self
        dieataryRestrictionView.dietaryTableView.dataSource = self
        allergiesView.allergiesTableView.delegate = self
        allergiesView.allergiesTableView.dataSource = self
    }

    // Mark: - KeyBordHeight
    func keyBoardHeight() {
    switch UIScreen.main.nativeBounds.height {
        case 2436:
             pageControlBottomConstaint.constant =  KeyBoard.height + 80
        case 2688:
            pageControlBottomConstaint.constant =  KeyBoard.height + 80
        case 1792:
           pageControlBottomConstaint.constant =  KeyBoard.height + 80
        default:
           pageControlBottomConstaint.constant =  KeyBoard.height + 40
        }
    }

       //Mark: - TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

         if textField == callNameView.callNameTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

        if textField == userNameView.userNameTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
        return true
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        currentView = currentView + 1
        if currentView == 0 {
            pageControl.currentPage = 0
        } else if currentView == 1 {
            if callNameView.callNameTextField.text != "" {
                pageControl.currentPage = 1
                backButton.setTitle("Back", for: .normal)
                 //backButton.isHidden = false
               // callNameView.callNameTextField.resignFirstResponder()
                userNameView.userNameTextField.becomeFirstResponder()
                User.profileName = (callNameView.callNameTextField.text?.trimmingCharacters(in: .whitespaces))!
                displayUserNameView()
            } else {
                alert(title: "Error!", message: "Name field should not Empty", cancel: "Dismiss")
                currentView = 0
            }
        } else if currentView == 2 {
            if userNameView.userNameTextField.text != "" {
                userNameView.userNameTextField.resignFirstResponder()
                pageControl.currentPage = 2
                User.userName = (userNameView.userNameTextField.text?.trimmingCharacters(in: .whitespaces))!
                // backButton.isHidden = false
                displayDieataryRestrictionView()
            } else {
                alert(title: "Error!", message: "UserName field should not Empty", cancel: "Dismiss")
                currentView = 1
            }
        } else if currentView == 3 {
            displayAllergiesArray()
            pageControl.currentPage = 3
            //backButton.isHidden = false
            nextButton.setTitle("Finish", for: .normal)
        } else {
             slideAPI()
        }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        nextButton.setTitle("Next", for: .normal)
        currentView = currentView - 1
        if currentView == 3 {
            displayAllergiesArray()
            pageControl.currentPage = 3
        } else if currentView == 2 {
            pageControl.currentPage = 2
            displayDieataryRestrictionView()
        } else if currentView == 1 {
            userNameView.userNameTextField.becomeFirstResponder()
            displayUserNameView()
            keyBoardHeight()
            pageControl.currentPage = 1
        } else if currentView == 0 {
            userNameView.userNameTextField.resignFirstResponder()
            callNameView.callNameTextField.becomeFirstResponder()
            displayCallNameView()
            keyBoardHeight()
            pageControl.currentPage = 0
            backButton.setTitle("", for: .normal)
        } else {
            currentView = 0
            backButton.setTitle("", for: .normal)
        }
    }

    // Mark: - Display CallNameView
    func displayCallNameView()  {
        UIView.animate(withDuration: 0.5, animations: {
            self.callNameView.frame = CGRect(x: 0 * self.slideView.frame.width,y: 0, width:self.slideView.frame.width , height:self.slideView.frame.height)
            self.userNameView.frame = CGRect(x: 1 * self.slideView.frame.width, y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.dieataryRestrictionView.frame = CGRect(x: 2 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.allergiesView.frame = CGRect(x: 3 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            //self.view.layoutIfNeeded()
        })
    }

     // Mark: - Display DisplayUserNameView
    func displayUserNameView()  {
        UIView.animate(withDuration: 0.5, animations: {
            self.callNameView.frame = CGRect(x: -1 * self.slideView.frame.width,y: 0, width:self.slideView.frame.width , height:self.slideView.frame.height)
            self.userNameView.frame = CGRect(x: 0 * self.slideView.frame.width, y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.dieataryRestrictionView.frame = CGRect(x: 1 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.allergiesView.frame = CGRect(x: 2 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            //self.view.layoutIfNeeded()
        })
    }

    // Mark: - Display DisplayDieataryRestrictionView
    func displayDieataryRestrictionView()  {
         pageControlBottomConstaint.constant =   20
        UIView.animate(withDuration: 0.5, animations: {
            self.callNameView.frame = CGRect(x: -2 * self.slideView.frame.width,y: 0, width:self.slideView.frame.width , height:self.slideView.frame.height)
            self.userNameView.frame = CGRect(x: -1 * self.slideView.frame.width, y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.dieataryRestrictionView.frame = CGRect(x: 0 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.allergiesView.frame = CGRect(x: 1 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            //self.view.layoutIfNeeded()
        })
    }

    // Mark: - Display DisplayAllergiesArray
    func displayAllergiesArray() {
        pageControlBottomConstaint.constant =   20
        UIView.animate(withDuration: 0.5, animations: {
            self.callNameView.frame = CGRect(x: -3 * self.slideView.frame.width,y: 0, width:self.slideView.frame.width , height:self.slideView.frame.height)
            self.userNameView.frame = CGRect(x: -2 * self.slideView.frame.width, y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.dieataryRestrictionView.frame = CGRect(x: -1 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            self.allergiesView.frame = CGRect(x: 0 * self.slideView.frame.width,y:0, width:self.slideView.frame.width,height:self.slideView.frame.height)
            //self.view.layoutIfNeeded()
        })
    }

  // Mark: - UPload Profile Info
  func slideAPI() {
        spinnerView.isHidden = false
        User.allergies = String(allergiesString.dropLast())
        let user = PFUser.current()
        user!["profileName"] = User.profileName
        user!["userDisplayName"] = User.userName
        user!["dieatryRestriction"] = User.dietaryRestrictions
        user!["allergies"] = User.allergies
        user!["following"] = 0
        user!["followers"] = 0
        user?.saveInBackground(block: { (success, error) in
            if (success) {
                self.navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.profileInfo, storyBoardId: ViewController.StoryBoardId.swipeStoryBoardId)
            } else {
                print(error ?? "Server error")
            }

            self.spinnerView.isHidden = true
        })
    }
}

extension SlideViewController {
      // Mark: - TableView data source
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dieataryRestrictionView.dietaryTableView  {
            return dietaryRestrictionsArray.count
        } else {
            return allergiesArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == allergiesView.allergiesTableView {
            let cell = allergiesView.allergiesTableView.dequeueReusableCell(withIdentifier: TableViewCell.ReuseIdentifier.allergies) as! AllergiesTableViewCell
            cell.selectionStyle = .none
            if allergiesBoolArray[indexPath.row] == true {
                cell.allergiesLabel.text = allergiesArray[indexPath.row]
                cell.allergiesLabel.backgroundColor = UIColor._lightningYellow
                cell.allergiesLabel.borderColor = UIColor.clear
                cell.allergiesLabel.clipsToBounds = true
                cell.allergiesLabel.cornerRadius = 10
            } else {
                cell.allergiesLabel.text = allergiesArray[indexPath.row]
                cell.allergiesLabel.backgroundColor = UIColor.white
                cell.allergiesLabel.textColor = UIColor._lightGray3
                cell.allergiesLabel.borderColor = UIColor._lightGray3
            }
            allergiesView.allergiesTableViewHeightConstraint.constant = allergiesView.allergiesTableView.contentSize.height + 50
            return cell
        } else {
            let cell  = dieataryRestrictionView.dietaryTableView.dequeueReusableCell(withIdentifier: TableViewCell.ReuseIdentifier.dieatary) as! DieataryTableViewCell
            cell.selectionStyle = .none
           if dietaryRestrictionsBoolArray[indexPath.row] == true {
                cell.dieataryLabel.text = dietaryRestrictionsArray[indexPath.row]
                cell.dieataryLabel.backgroundColor = UIColor._lightningYellow
                cell.dieataryLabel.borderColor = UIColor.clear
                cell.dieataryLabel.clipsToBounds = true
                cell.dieataryLabel.cornerRadius = 10
                cell.dieataryLabel.textColor = UIColor.white
            } else {
                cell.dieataryLabel.text = dietaryRestrictionsArray[indexPath.row]
                cell.dieataryLabel.backgroundColor = UIColor.white
                cell.dieataryLabel.textColor = UIColor._lightGray3
                cell.dieataryLabel.borderColor = UIColor._lightGray3
            }
            return cell
        }
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == allergiesView.allergiesTableView {
            let indexPath = allergiesView.allergiesTableView.indexPathForSelectedRow!
            let cell = allergiesView.allergiesTableView.cellForRow(at: indexPath) as! AllergiesTableViewCell
             if indexPath.row != allergiesArray.count - 1 {
                if allergiesBoolArray[indexPath.row] == true {
                    allergiesBoolArray[indexPath.row] = false
                    cell.allergiesLabel.text = allergiesArray[indexPath.row]
                    cell.allergiesLabel.backgroundColor = UIColor._lightningYellow
                    cell.allergiesLabel.borderColor = UIColor.clear
                    cell.allergiesLabel.clipsToBounds = true
                    cell.allergiesLabel.cornerRadius = 10
                    cell.allergiesLabel.textColor = UIColor.white
                    User.allergies.append(String(indexPath.row))
                    selectAllergies(tag: indexPath.row)
                }  else {
                    allergiesBoolArray[indexPath.row] = true
                    cell.allergiesLabel.text = allergiesArray[indexPath.row]
                    cell.allergiesLabel.backgroundColor = UIColor.white
                    cell.allergiesLabel.textColor = UIColor._lightGray3
                    cell.allergiesLabel.borderColor = UIColor._lightGray3
                   selectAllergies(tag: indexPath.row)
                }
                 allergiesBoolArray[allergiesArray.count - 1] = false
            } else {
                allergiesBoolArray.removeAll()
                allergiesString = "8,"
                allergiesBoolArray = [false, false, false, false, false, false, false, false, true]
            }

            if allergiesBoolArray[0] == false   && allergiesBoolArray[1]  == false  && allergiesBoolArray[2]  == false && allergiesBoolArray[3]  == false && allergiesBoolArray[4]  == false && allergiesBoolArray[5] == false && allergiesBoolArray[6]  == false && allergiesBoolArray[7] == false {
                allergiesBoolArray[allergiesArray.count - 1] = true
                cell.allergiesLabel.text = allergiesArray[indexPath.row]
                    cell.allergiesLabel.backgroundColor = UIColor._lightningYellow
                    cell.allergiesLabel.borderColor = UIColor.clear
                     cell.allergiesLabel.textColor = UIColor.white
                selectAllergies(tag: indexPath.row)
                allergiesString = "8,"
            }
            allergiesView.allergiesTableView.reloadData()
        } else {
            let indexPath = dieataryRestrictionView.dietaryTableView.indexPathForSelectedRow!
                for (i,_) in dietaryRestrictionsBoolArray.enumerated() {
                    if i == indexPath.row {
                        dietaryRestrictionsBoolArray[i] = true
                        User.dietaryRestrictions = Double(i)
                    } else {
                        dietaryRestrictionsBoolArray[i] = false
                    }
                }
            dieataryRestrictionView.dietaryTableView.reloadData()
        }
     }

    func selectAllergies(tag:Int) {
        for (i,_) in allergiesArray.enumerated() {
            if i == tag {
                if allergiesBoolArray[i] == true {
                      allergiesString = allergiesString.replacingOccurrences(of:"8,", with: "", options: .literal, range: nil)
                      allergiesString = allergiesString.replacingOccurrences(of:"8", with: "", options: .literal, range: nil)
                    allergiesString = "\(allergiesString + "\(i)"),"
                } else {
                    allergiesString = allergiesString.replacingOccurrences(of:"\(i),", with: "", options: .literal, range: nil)
                }
            }
        }
    }
}


// kgb mm ;m    . ,,,,,';,,',,  '; kk m  knkl ;m;n ;lk  kh lnk kln link kjb  kbkk n olm,m jv


