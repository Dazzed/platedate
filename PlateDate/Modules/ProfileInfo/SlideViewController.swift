//
//  SlideViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 07/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Mark: - @IBOutlets
    @IBOutlet var slideView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var pageControlBottomConstaint: NSLayoutConstraint!
    @IBOutlet var nextButton: UIButton!

    // Mark: - @Declaration
    var callNameView = CallNameView()
    var userNameView = UserNameView()
    var dieataryRestrictionView = DietaryRestrictionsView()
    var allergiesView = AllergiesView()
    var currentView:CGFloat = 0
     var allergiesArray = ["Dairy", "Egg", "Peanut", "Tree Nut", "Seafood", "Sesame", "Soy", "None"]
     var dietaryRestrictionsArray = ["Vegetarian", "Pescetarian", "Vegan", "None" ]

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
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    // Mark: - Load CallNameView
    func loadCallNameView() {
        callNameView = (Bundle.main.loadNibNamed(XibName.callNameView, owner: self, options: nil)?.first as? CallNameView)!
        callNameView.frame = CGRect(x: 0,y: 0, width:slideView.frame.width , height:slideView.frame.height)
        callNameView.callNameTextField.becomeFirstResponder()
        slideView.addSubview(callNameView)
    }

    // Mark: - Load UserNameView
    func loadUserNameView() {
        userNameView = (Bundle.main.loadNibNamed(XibName.userNameView, owner: self, options: nil)?.first as? UserNameView)!
        userNameView.frame = CGRect(x: 1 * slideView.frame.width ,y: 0, width:slideView.frame.width, height:slideView.frame.height)
        slideView.addSubview(userNameView)
    }

    // Mark: - Load DieataryRestrictionView
    func loadDieataryRestrictionView() {
        dieataryRestrictionView = (Bundle.main.loadNibNamed(XibName.dieatrayRestrictionView, owner: self, options: nil)?.first as? DietaryRestrictionsView)!
        dieataryRestrictionView.frame = CGRect(x: 2 * slideView.frame.width ,y: 0, width:slideView.frame.width, height:slideView.frame.height)
        slideView.addSubview(dieataryRestrictionView)
    }

    // Mark: - Load AllergiesView
    func loadAllergiesView() {
         allergiesView = (Bundle.main.loadNibNamed(XibName.allergiesView, owner: self, options: nil)?.first as? AllergiesView)!
        allergiesView.frame = CGRect(x: 3 * slideView.frame.width ,y: 0, width:slideView.frame.width, height:slideView.frame.height)
        slideView.addSubview(allergiesView)
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

    @IBAction func nextButtonAction(_ sender: Any) {
        currentView = currentView + 1
        if currentView == 0 {
            displayCallNameView()
            pageControl.currentPage = 0
        } else if currentView == 1 {
            displayUserNameView()
            pageControl.currentPage = 1
            callNameView.callNameTextField.resignFirstResponder()
            userNameView.userNameTextField.becomeFirstResponder()
        } else if currentView == 2 {
            userNameView.userNameTextField.resignFirstResponder()
            pageControl.currentPage = 2
            displayDieataryRestrictionView()
        } else if currentView == 3 {
            displayAllergiesArray()
            pageControl.currentPage = 3
            nextButton.setTitle("Finish", for: .normal)
        } else {
            navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.profileInfo, storyBoardId: ViewController.StoryBoardId.swipeStoryBoardId)
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
            //let totalRow: Int = tableView.numberOfRows(inSection: indexPath.section) //first get total rows in that section by current indexPath.
            if allergiesArray[indexPath.row] == "None" {
                print(allergiesArray[indexPath.row])
                cell.allergiesLabel.text = allergiesArray[indexPath.row]
                cell.allergiesLabel.backgroundColor = UIColor._lightningYellow
                cell.allergiesLabel.borderColor = UIColor.clear
                cell.allergiesLabel.clipsToBounds = true
                cell.allergiesLabel.cornerRadius = 10
            } else {
                cell.allergiesLabel.text = allergiesArray[indexPath.row]
            }
            allergiesView.allergiesTableViewHeightConstraint.constant = allergiesView.allergiesTableView.contentSize.height + 50
            return cell
        } else {
            let cell  = dieataryRestrictionView.dietaryTableView.dequeueReusableCell(withIdentifier: TableViewCell.ReuseIdentifier.dieatary) as! DieataryTableViewCell
            cell.selectionStyle = .none
            let totalRow: Int = tableView.numberOfRows(inSection: indexPath.section)
           if indexPath.row == totalRow - 1 {
                cell.dieataryLabel.text = dietaryRestrictionsArray[indexPath.row]
                cell.dieataryLabel.backgroundColor = UIColor._lightningYellow
                cell.dieataryLabel.borderColor = UIColor.clear
                cell.dieataryLabel.clipsToBounds = true
                cell.dieataryLabel.cornerRadius = 10
            } else {
                cell.dieataryLabel.text = dietaryRestrictionsArray[indexPath.row]
            }
            return cell
        }
    }
}
