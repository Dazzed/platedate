//
//  editRecipeViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 11/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import ImagePicker
import EasyPopUp
import Photos
import TableViewDragger
import Parse
import Alamofire


class editRecipeViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate {

    //Mark: - @IBOutlets
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeModeSwitch: UISwitch!
    @IBOutlet var imageRemoveButton: UIButton!
    @IBOutlet var recipeTitleView: UIView!
    @IBOutlet var recipeDescriptionView: UIView!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var recipeTitleTextView: UITextView!
    @IBOutlet var servingsTextField: UITextField!
    @IBOutlet var privateLabel: UILabel!
    @IBOutlet var imageIconView: UIView!

    //Mark: - Time Picker
   @IBOutlet var timePickerPopupView: UIView!
   @IBOutlet var timePicker: GSTimeIntervalPicker!
   @IBOutlet var timeTextField: UITextField!
   @IBOutlet var timeNeededView: UIView!

   //Mark: - CookWare
    @IBOutlet var addCookWareTableView: UITableView!
    @IBOutlet var addCookWarePopUpView: UIView!
    @IBOutlet var addCookWareTextField: UITextField!
    @IBOutlet var cookwareViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var addCookWareTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var addCookWareButtonTopConstraint: NSLayoutConstraint!

    //Mark: - AddIngredient
    @IBOutlet var addIngredientView: UIView!
    @IBOutlet var addIngredientPopUpView: UIView!
    @IBOutlet var addIngredientNameTextField: UITextField!
    @IBOutlet var addIngredientAmountTextField: UITextField!
    @IBOutlet var addIngredientTableView: UITableView!
    @IBOutlet var ingredientViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var addIngredientTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var addIngredientButtonTopConstraint: NSLayoutConstraint!

    //Mark: - AddStep
    @IBOutlet var addStepPopUpView: UIView!
    @IBOutlet var addStepTextView: UITextView!
    @IBOutlet var addStepTableView: UITableView!
    @IBOutlet var stepViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var addStepTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var addStepButtonTopConstraint: NSLayoutConstraint!
    

    //Mark: - Error
    @IBOutlet var errorPopUpView: UIView!
    var dragger: TableViewDragger!
    @IBOutlet var editRecipeScrollView: UIScrollView!
    @IBOutlet weak var recipeTitleCharacterCountLabel: UILabel!
    @IBOutlet weak var recipeDescriptionCahracterCountLabel: UILabel!
    @IBOutlet weak var addStepCharacterCountLabel: UILabel!
    @IBOutlet weak var ingredientErrorLabel: UILabel!

    @IBOutlet var uploadSuccessPopUPView: UIView!

    @IBOutlet weak var successMessageLabel: UILabel!

    var convertMins:String = ""
    //Mark: - @Declaration
    var popUpConfig = EasyPopupConfig()
    var updateTime:Double = 0
    var recipeImage = UIImage()
    let screenSize = UIScreen.main.bounds
      var editCellBool:Bool = false
    var cellIndex:Int = 0
    var nutirion = [[String:AnyObject]]()

    //Mark: - TimePickerPopUpView
    lazy var timePickerPopUpView : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: timePickerPopupView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    //Mark: - AddCookWarePopUp
     lazy var addCookWarePopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: addCookWarePopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

       //Mark: - AddIngredientPopUp
      lazy var addIngredientPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: addIngredientPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

     //Mark: - AddStepPopUp
     lazy var addStepPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: addStepPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

    //Mark: - ErrorPopUp
    lazy var errorPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: errorPopUpView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

     lazy var uploadSuccessPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: uploadSuccessPopUPView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()

//     //lazy var viewControllerPopup : EasyViewControllerPopup = {
//        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "UserLogin") as! UserLoginViewController
//        let easePopUp = EasyViewControllerPopup(sourceViewController: self, destinationViewController: popupVC )
//         popUpConfig.animationType = .scale
//         popUpConfig.animaionDuration = 0.3
//        return easePopUp
//    }()

//Profile
//BookMark
//AddRecipe
//Grocery

    override func viewDidLoad() {
        super.viewDidLoad()
        //getRecipeAPI()
        recipeModeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        timePickerPopUp()
        tapGustureRecognizer()
        delegates()
        addCookWareReuseIdentifier()
        addIngredientResueIdentifier()
        addStepResueIdentifier()
        getRecipeAPI()

        addCookWareTableView.reloadData()
        addStepTableView.reloadData()
        addIngredientTableView.reloadData()
        setupLongPressGesture()
        draggerTableView()
    }

      func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5 // 1 second press
        longPressGesture.delegate = self
        addStepTableView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            editRecipeScrollView.isScrollEnabled = false
        } else if gestureRecognizer.state == .ended {
            editRecipeScrollView.isScrollEnabled = true
        }
    }

    func draggerTableView() {
        dragger = TableViewDragger(tableView: addStepTableView)
      //  dragger.availableHorizontalScroll = true
        dragger.dataSource = self
        dragger.delegate = self
        dragger.alphaForCell = 0.7
        addStepTableView.reloadData()
    }

      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

   func getRecipeAPI() {
        let query = PFQuery(className: "Recipe")
        query.whereKey("objectId", equalTo: getRecipe.recipeObjectId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                for object in objects! {

                    getRecipe.recipeMode = object["recipeMode"] as! String
                    if object["recipeTitle"] != nil {
                        getRecipe.recipeTitle = object["recipeTitle"] as! String
                    }

                    if object["recipeDescription"] != nil {
                         getRecipe.recipeDescription =  object["recipeDescription"] as! String
                    }

                    if object["preparationTime"] != nil {
                         getRecipe.prepatationTime = object["preparationTime"] as! String
                    }

                    if object["servings"] != nil {
                        getRecipe.servings = object["servings"] as! String
                    }

                     if object["recipeCookWare"] != nil {
                        getRecipe.recipeCookWareArray = object["recipeCookWare"] as! [String]
                    }

                    if object["recipeIngredient"] != nil {
                        getRecipe.recipeIngredientArray = object["recipeIngredient"] as! [String]
                    }

                    if object["recipeIngredientAmount"] != nil {
                        getRecipe.recipeIngredientAmountArray = object["recipeIngredientAmount"] as! [String]
                    }

                     if object["recipeAddStep"] != nil {
                        getRecipe.recipeAddStepArray = object["recipeAddStep"] as! [String]
                    }

                    if object["recipeImage"] != nil {
                        self.retriveImage()
                    } else {
                        self.display()
                    }
                }
            }
        }
    }

    @IBAction func action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func retriveImage() {
        print("retrive image")
        let query = PFQuery(className:"Recipe")
        query.getObjectInBackground(withId: getRecipe.recipeObjectId) { (gameScore: PFObject?, error: Error?) in
            if let error = error {
                //The query returned an error
                print(error.localizedDescription)
            } else {
                //The object has been retrieved
                let userImageFile = gameScore!["recipeImage"] as! PFFileObject
                userImageFile.getDataInBackground { (imageData: Data?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.recipeImageView.image = image
                        self.imageRemoveButton.isHidden = false
                        self.imageIconView.isHidden = true
                        self.display()
                    }
                }
            }
        }
    }

    func display() {
        if getRecipe.recipeMode == "0" {
            recipeModeSwitch.setOn(true, animated: true)
            privateLabel.text = "I want this recipe to be Published"
        } else {
            recipeModeSwitch.setOn(false, animated: true)
            privateLabel.text = "I want this recipe to be Private"
        }

        recipeTitleTextView.text = getRecipe.recipeTitle
        descriptionTextView.text = getRecipe.recipeDescription
        timeTextField.text = getRecipe.prepatationTime
        servingsTextField.text = getRecipe.servings

        recipeTitleCharacterCountLabel.text = ""
        recipeTitleCharacterCountLabel.text = String("\(getRecipe.recipeTitle.count)/50 characters")
        recipeDescriptionCahracterCountLabel.text = String("\(getRecipe.recipeDescription.count)/300 characters")
        addCookWareTableView.reloadData()
        addIngredientTableView.reloadData()
        addStepTableView.reloadData()
    }

    func popUPWidth() {
        timePickerPopupView.frame = CGRect(x:timePickerPopupView.frame.origin.x, y:timePickerPopupView.frame.origin.y,  width:screenSize.width, height:timePickerPopupView.frame.height)
        addCookWarePopUpView.frame = CGRect(x:addCookWarePopUpView.frame.origin.x, y:addCookWarePopUpView.frame.origin.y,  width:screenSize.width, height:addCookWarePopUpView.frame.height)
        addIngredientView.frame = CGRect(x:addIngredientView.frame.origin.x, y:addIngredientView.frame.origin.y,  width:screenSize.width, height:addIngredientView.frame.height)
        addStepPopUpView.frame = CGRect(x:addStepPopUpView.frame.origin.x, y:addStepPopUpView.frame.origin.y,  width:screenSize.width, height:addStepPopUpView.frame.height)
    }

    //Mark: - Delegates
    func delegates() {
        recipeTitleTextView.delegate = self
        descriptionTextView.delegate = self
        addCookWareTextField.delegate = self
        addIngredientNameTextField.delegate = self
        addIngredientAmountTextField.delegate = self
        addStepTextView.delegate = self
    }
    
    //Mark: - AddCookWare ReuseIdentifier
    func addCookWareReuseIdentifier() {
        addCookWareTableView.delegate = self
        addCookWareTableView.dataSource = self
        addCookWareTableView.separatorStyle = .none
        addCookWareTableView.register(UINib(nibName: TableViewCell.ClassName.addCookWare, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.addCookWare)

    }

     //Mark: - AddIngredient ReuseIdentifier
    func addIngredientResueIdentifier() {
        addIngredientTableView.delegate = self
        addIngredientTableView.dataSource = self
        addIngredientTableView.separatorStyle = .none
        addIngredientTableView.register(UINib(nibName: TableViewCell.ClassName.addIngredient, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.addIngredient)
    }

    //Mark: - AddStep ReuseIdentifier
    func addStepResueIdentifier() {
        addStepTableView.delegate = self
        addStepTableView.dataSource = self
        addStepTableView.separatorStyle = .none
        addStepTableView.register(UINib(nibName: TableViewCell.ClassName.addStep, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.addStep)
    }

     //Mark: - TimePicker
    func timePickerPopUp() {
        timePicker.maxTimeInterval = 3600 * 12 // set the limit
        timePicker.minuteInterval = 5 // the step. Default is 1 minute
        timePicker.timeInterval = 0 // 1 h 30 minutes
        timePicker.setTimeInterval(0, animated: true)
        timePicker.onTimeIntervalChanged = { newTimeInterval in
            self.secondsToHoursMinutes(seconds: Int(newTimeInterval))
            _ = moment(newTimeInterval)
        }
    }

      //Mark: - seconds To Hours & Minutes
      func secondsToHoursMinutes (seconds : Int) {
        //print(seconds / 3600, (seconds % 3600) / 60)
        let hour = Int(seconds / 3600)
        convertMins = String(seconds / 60)
        let mins = Int((seconds % 3600) / 60)
        if hour == 0  {
            timeTextField.text = "\(mins) Mins"
        } else if  hour == 1 {
            timeTextField.text = "\(hour) Hr, \(mins) Mins"
        } else {
             timeTextField.text = "\(hour) Hrs, \(mins) Mins"
        }
    }

    //Mark: - TextView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == recipeTitleTextView {
            if range.location == 0 {
                let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            } else {
                if(textView.text.count > 50) {
                    print("Please summarize in 20 characters or less")
                    return false
                }
            }
        }

        if textView == descriptionTextView {
            if range.location == 0 {
                let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            } else {
                if(textView.text.count > 300) {
                    print("Please summarize in 300 characters or less")
                    return false
                }
            }
        }

         if textView == addStepTextView {
            if range.location == 0 {
                let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            } else {
                if(textView.text.count > 300) {
                    print("Please summarize in 300 characters or less")
                    return false
                }
            }
        }
        return true
    }

     //Mark: - TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

         if textField == addCookWareTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

        if textField == addIngredientNameTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

        if textField == addIngredientAmountTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

//        if textField == addIngredientAmountTextField {
//            let numberOnly = NSCharacterSet.init(charactersIn: "0123456789.")
//            let stringFromTextField = NSCharacterSet.init(charactersIn: string)
//            let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
//            return strValid
//        }

        if textField == servingsTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }

        return true
    }

    func textViewDidChange(_ textView: UITextView) {

        if textView == recipeTitleTextView {
             recipeTitleCharacterCountLabel.text = String("\(textView.text.count)/50 characters")
             print("Please summarize in 50 characters or less")
        }

        if textView == descriptionTextView {
            recipeDescriptionCahracterCountLabel.text = String("\(textView.text.count)/300 characters")
        }

        if textView == addStepTextView {
            addStepCharacterCountLabel.text = String("\(textView.text.count)/300 characters")
        }

    }

     //Mark: - TapGustureRecognizer for View click Function
    func tapGustureRecognizer() {
        let timeNeededViewtap = UITapGestureRecognizer(target: self, action: #selector(AddRecipeViewController.timePickerPopUP))
        timeNeededView.addGestureRecognizer(timeNeededViewtap)
    }

    //Mark: - Change Private and publish mode
    @IBAction func switchChangeAction(_ sender: UISwitch) {
        if sender.isOn {
            getRecipe.recipeMode = "0"
            privateLabel.text = "I want this recipe to be Published"
        } else {
            privateLabel.text = "I want this recipe to be Private"
            getRecipe.recipeMode = "1"
        }
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
        recipeImageView.image = nil
        imageIconView.isHidden = false
        recipeImageView.backgroundColor = UIColor._lightGray5
    }

    //Mark: - TimePickerAction submit & cancel
     @objc func timePickerPopUP() {
        view.endEditing(true)
        timePickerPopUpView.config = popUpConfig
        popUpConfig.cornerRadius = 10
        timePickerPopUpView.showPopup { (isfinished) in
            print(isfinished)
        }
    }

    @IBAction func timePickerSubmitAction(_ sender: Any) {
        timePickerPopUpView.removePopup { (isfinished) in
            print(isfinished)
        }
    }

     @IBAction func timePickerCancelAction(_ sender: Any) {
        timePickerPopUpView.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    //Mark: - AddCookware submit & cancel
    @IBAction func addCookwareButtonAction(_ sender: Any) {
        addCookWarePopUp.config = popUpConfig
        editCellBool = false
        addCookWarePopUp.showPopup { (isfinished) in
            print(isfinished)
            self.addCookWareTextField.becomeFirstResponder()
        }
    }

    @IBAction func addCookwareSubmitAction(_ sender: Any) {
        let addCookWare = self.addCookWareTextField.text!.trimmingCharacters(in: .whitespaces)
        if addCookWare.isEmpty {
            print("error")
        } else {
            if editCellBool == false  {
                cookwareViewTopConstraint.constant = 23
                addCookWareButtonTopConstraint.constant = 15
                getRecipe.recipeCookWareArray.append(addCookWare)
                self.addCookWareTableView.reloadData()
                addCookWarePopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addCookWareTextField.text = ""
                }
            } else {
                addCookWareTextField.becomeFirstResponder()
                getRecipe.recipeCookWareArray[cellIndex] =  self.addCookWareTextField.text!
                addCookWareTableView.reloadData()
                addCookWarePopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addCookWareTextField.text = ""
                }
            }
        }
    }

     @IBAction func addCookwareCancelAction(_ sender: Any) {
        addCookWarePopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    //Mark: - AddIngredient submit & cancel
    @IBAction func addIngredientButtonAction(_ sender: Any) {
        addIngredientPopUp.config = popUpConfig
        editCellBool = false
        addIngredientPopUp.showPopup { (isfinished) in
            print(isfinished)
            self.addIngredientNameTextField.becomeFirstResponder()
        }
    }

    @IBAction func addIngredientSubmitAction(_ sender: Any) {
        let addIngredientName = addIngredientNameTextField.text!.trimmingCharacters(in: .whitespaces)
        let addIngredientAmount = addIngredientAmountTextField.text!.trimmingCharacters(in: .whitespaces)
        if addIngredientName.isEmpty {
            print("error")
        } else if addIngredientAmount.isEmpty {
             print("error")
        }else {
           if editCellBool == false {
                getNutritionValues(ingredientAmount: addIngredientAmount, ingredientName: addIngredientName)
            } else {
                addIngredientNameTextField.becomeFirstResponder()
                getEditNutritionValues(ingredient:"\(addIngredientAmount) \(addIngredientName)", index: cellIndex)
            }
        }
    }

      @IBAction func addIngredientCancelAction(_ sender: Any) {
        addIngredientPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    //Mark - AddStepButtonAction submit & cancel
    @IBAction func addStepButtonAction(_ sender: Any) {
        addStepPopUp.config = popUpConfig
        editCellBool = false
        addStepPopUp.showPopup { (isfinished) in
            print(isfinished)
            self.addStepTextView.becomeFirstResponder()
        }
    }

    @IBAction func addStepSubmitButtonAction(_ sender: Any) {
          let addstep = addStepTextView.text!.trimmingCharacters(in: .whitespaces)
           if addstep.isEmpty {
            print("error")
        } else {
            if editCellBool == false {
                stepViewTopConstraint.constant = 23
                addStepButtonTopConstraint.constant = 15
                getRecipe.recipeAddStepArray.append(addstep)
                self.addStepTableView.reloadData()
                addStepPopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addStepTextView.text = ""
                }
            } else {
                getRecipe.recipeAddStepArray[self.cellIndex] = self.addStepTextView.text
                self.addStepTableView.reloadData()
                 addStepPopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addStepTextView.text = ""
                }
            }
        }
    }

    @IBAction func addStepCancelButtonAction(_ sender: Any) {
        addStepPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }

    @IBAction func uploadButtonAction(_ sender: Any) {
        editRecipeValues()
        if getRecipe.recipeMode == "1" {
            editRecipeAPI()
        } else {
            print(getRecipe.recipeTitle)
            requireFieldsAPI()
        }
    }

    func editRecipeValues() {
        print(getRecipe.recipeTitle)
        getRecipe.recipeTitle = recipeTitleTextView.text!.trimmingCharacters(in: .whitespaces)
        print(getRecipe.recipeTitle)
        getRecipe.recipeDescription = descriptionTextView.text!.trimmingCharacters(in: .whitespaces)
        getRecipe.servings = servingsTextField.text!
        getRecipe.prepatationTime = timeTextField.text!.trimmingCharacters(in: .whitespaces)
    }

    func editRecipeAPI() {

        if getRecipe.recipeMode == "0" {
            successMessageLabel.text = "Your recipe has been published"
        } else {
            successMessageLabel.text = "Your private recipe has been uploaded"
        }

        let query = PFQuery(className: "Recipe")
        query.whereKey("objectId", equalTo: getRecipe.recipeObjectId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                for object in objects! {
                    print(getRecipe.recipeTitle)
                    if self.recipeTitleTextView.text != "" {
                        print(getRecipe.recipeTitle)
                        object["recipeTitle"] = getRecipe.recipeTitle
                    }
                    print(getRecipe.recipeTitle)

                     if self.descriptionTextView.text != "" {
                        object["recipeDescription"] = getRecipe.recipeDescription
                    }

                     if self.servingsTextField.text != "" {
                         object["servings"] = getRecipe.servings
                    }

                    if self.timeTextField.text != "" {
                        object["preparationTime"] = getRecipe.prepatationTime
                    }

                    if getRecipe.recipeCookWareArray.count != 0 {
                         object["recipeCookWare"] = getRecipe.recipeCookWareArray
                         object["nutritionFacts"] = self.nutirion
                    }

                     if getRecipe.recipeIngredientArray.count != 0 {
                        object["recipeIngredient"] = getRecipe.recipeIngredientArray
                    }

                     if getRecipe.recipeIngredientAmountArray.count != 0 {
                        object["recipeIngredientAmount"] = getRecipe.recipeIngredientAmountArray
                    }

                    if getRecipe.recipeAddStepArray.count != 0 {
                        object["recipeAddStep"] = getRecipe.recipeAddStepArray
                    }

                     // Image
                    if self.recipeImageView.image != nil {
                        let imageData = UIImageJPEGRepresentation(self.recipeImageView.image!, 0.5)
                        let imageFile = PFFileObject(name:"avatar.jpg", data:imageData!)
                        object["recipeImage"] = imageFile
                    }

                    object["recipeMode"] = getRecipe.recipeMode
                    object.saveInBackground()

                     self.uploadSuccessPopUp.showPopup { (isfinished) in
                        print(isfinished)
                       // self.popupRemove()

                    }
                }
            }
        }
    }

     func popupRemove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
             self.uploadSuccessPopUp.removePopup()
        }
    }

    func requireFieldsAPI() {

        if recipeImageView.image == nil || getRecipe.recipeTitle.isEmpty || getRecipe.recipeDescription.isEmpty || getRecipe.prepatationTime.isEmpty || getRecipe.servings.isEmpty ||  getRecipe.recipeCookWareArray.count == 0 ||  getRecipe.recipeIngredientArray.count == 0 ||  getRecipe.recipeAddStepArray.count == 0  {
            errorPopUp.config = popUpConfig
            errorPopUp.showPopup { (isfinished) in
                print(isfinished)
            }
        } else {
          editRecipeAPI()
        }
    }

     @IBAction func errorDismissButtonAction(_ sender: Any) {
        errorPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }


    func getNutritionValues(ingredientAmount:String, ingredientName:String) {
            self.view.isUserInteractionEnabled = false
            let url = "https://api.edamam.com/api/nutrition-data?&app_id=e554574a&app_key=accaf9ed827ac7499e886c4b817df065"
            Alamofire.request(url, parameters: ["ingr": "\(ingredientAmount) \(ingredientName)"]).responseJSON { response in
                let dictionary = response.result.value as?[String:AnyObject]
                if dictionary!["totalWeight"] as! Double == 0.0 {
                    self.ingredientErrorLabel.text = "Please Enter valid ingrident data"
                    self.view.isUserInteractionEnabled = true
                } else {
                    self.ingredientViewTopConstraint.constant = 23
                    self.addIngredientButtonTopConstraint.constant = 15
                    self.nutirion.append(dictionary!)
                    self.ingredientErrorLabel.text = ""
                    getRecipe.recipeIngredientArray.append(ingredientName)
                    getRecipe.recipeIngredientAmountArray.append(ingredientAmount)
                    self.addIngredientTableView.reloadData()
                    self.addIngredientPopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addIngredientNameTextField.text = ""
                    self.addIngredientAmountTextField.text = ""
                    self.view.isUserInteractionEnabled = true 
                }
            }
        }
    }

     func getEditNutritionValues(ingredient:String, index:Int) {
            let url = "https://api.edamam.com/api/nutrition-data?&app_id=e554574a&app_key=accaf9ed827ac7499e886c4b817df065"
            Alamofire.request(url, parameters: ["ingr": ingredient]).responseJSON { response in
                let dictionary = response.result.value as?[String:AnyObject]
                if dictionary!["totalWeight"] as! Double == 0.0 {
                    self.ingredientErrorLabel.text = "Please Enter valid ingrident data"
                } else {
                    self.nutirion[index] = dictionary!
                    getRecipe.recipeIngredientArray[index] =  self.addIngredientNameTextField.text!
                    getRecipe.recipeIngredientArray[index] =  self.addIngredientAmountTextField.text!
                    self.addIngredientTableView.reloadData()
                    self.addIngredientPopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addIngredientNameTextField.text = ""
                    self.addIngredientAmountTextField.text = ""
                }
            }
        }
    }
}

extension editRecipeViewController: UITableViewDelegate, UITableViewDataSource, TableViewDraggerDataSource, TableViewDraggerDelegate {
    //Mark: - ImagePicker Delegate Methods
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {

    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count != 0 {
            recipeImageView.image = images[0]
            imageRemoveButton.isHidden = false
            imageIconView.isHidden = true
            self.dismiss(animated: true, completion: nil)
            let bundle = Bundle(for: AssetManager.self)
            print(bundle.resourcePath ?? "sdfdsf")

          //  var webData: Data? = UIImagePNGRepresentation(recipeImageView.image!)
            var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            getRecipe.filePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("png").absoluteString
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - TableView Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == addCookWareTableView {
            print(getRecipe.recipeCookWareArray.count)
             return getRecipe.recipeCookWareArray.count
         } else if tableView == addIngredientTableView {
             return getRecipe.recipeIngredientArray.count
        } else {
            return getRecipe.recipeAddStepArray.count
        }
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == addStepTableView {
//            return UITableViewAutomaticDimension
//        } else {
//             return 45.0
//        }
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addCookWareTableView {
            let cell = addCookWareTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.addCookWare) as! AddCookWareTableViewCell
             cell.selectionStyle = .none
             cell.addCookWareCancelButton.tag = indexPath.row
             cell.addCookWareCancelButton.addTarget(self, action: #selector(removeCookwareButtonAction), for: .touchUpInside)
            cell.addCookWareLabel.text = getRecipe.recipeCookWareArray[indexPath.row]
             cookwareViewTopConstraint.constant = 23
             addCookWareTableViewHeightConstraint.constant = addCookWareTableView.contentSize.height + 10
            return cell
        } else if tableView == addIngredientTableView {
             let cell = addIngredientTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.addIngredient) as! AddIngredientTableViewCell
              cell.selectionStyle = .none
            cell.addIngredientNameLabel.text = getRecipe.recipeIngredientArray[indexPath.row]

            cell.addIngredientNameLabel.text = "\(getRecipe.recipeIngredientAmountArray[indexPath.row]) \(getRecipe.recipeIngredientArray[indexPath.row]) "


              ingredientViewTopConstraint.constant = 23
              addIngredientTableViewHeightConstraint.constant = addIngredientTableView.contentSize.height + 10

              cell.removeIngredientButton.addTarget(self, action: #selector(removeIngredientButtonAction), for: .touchUpInside)
             return cell
        } else {
            let cell = addStepTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.addStep) as! AddStepTableViewCell
            cell.selectionStyle = .none
            cell.addStepLabel.text = getRecipe.recipeAddStepArray[indexPath.row]
            cell.stepCountLabel.text = String(indexPath.row + 1)
            stepViewTopConstraint.constant = 23
            addStepTableViewHeightConstraint.constant = addStepTableView.contentSize.height + 10
             cell.stepRemoveButton.addTarget(self, action: #selector(removeStepButtonAction), for: .touchUpInside)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if tableView == addStepTableView {
            let indexPath = addStepTableView.indexPathForSelectedRow!
            addStepPopUp.config = popUpConfig
            addStepPopUp.showPopup { (isfinished) in
                print(isfinished)
                self.addStepTextView.becomeFirstResponder()
                self.addStepTextView.text = getRecipe.recipeAddStepArray[indexPath.row]
                self.editCellBool = true
                self.cellIndex = indexPath.row
                self.addStepCharacterCountLabel.text = String("\(getRecipe.recipeAddStepArray[indexPath.row].count)/300 characters")
            }
        } else if tableView == addIngredientTableView {
            let indexPath = addIngredientTableView.indexPathForSelectedRow!
            addIngredientPopUp.config = popUpConfig
            addIngredientPopUp.showPopup { (isfinished) in
                print(isfinished)
                self.addIngredientNameTextField.becomeFirstResponder()
                self.addIngredientNameTextField.text = getRecipe.recipeIngredientArray[indexPath.row]
                self.addIngredientAmountTextField.text = getRecipe.recipeIngredientAmountArray[indexPath.row]
                self.editCellBool = true
                self.cellIndex = indexPath.row
            }
        } else {
                let indexPath = addCookWareTableView.indexPathForSelectedRow!
                addCookWarePopUp.config = popUpConfig
                addCookWarePopUp.showPopup { (isfinished) in
                print(isfinished)
                self.addCookWareTextField.becomeFirstResponder()
                self.addCookWareTextField.text = getRecipe.recipeCookWareArray[indexPath.row]
                self.editCellBool = true
                self.cellIndex = indexPath.row
            }
        }
    }

      //Mark: - Remove Cookware
      @objc func removeCookwareButtonAction(_ sender: Any) {
        let button = sender as? UIButton
        let cell1 = button?.superview?.superview as? AddCookWareTableViewCell
        let indexPath = addCookWareTableView.indexPath(for: cell1!)!
        getRecipe.recipeCookWareArray.remove(at: indexPath.row)
        if getRecipe.recipeCookWareArray.count == 0 {
            cookwareViewTopConstraint.constant = -2
            addCookWareButtonTopConstraint.constant = 23
            addCookWareTableViewHeightConstraint.constant = 1
        } else {
            addCookWareTableView.reloadData()
        }
    }

    //Mark: - Remove Ingredient
    @objc func removeIngredientButtonAction(_ sender: Any) {
        let button = sender as? UIButton
        let cell1 = button?.superview?.superview as? AddIngredientTableViewCell
        let indexPath = addIngredientTableView.indexPath(for: cell1!)!
        getRecipe.recipeIngredientArray.remove(at: indexPath.row)
        getRecipe.recipeIngredientAmountArray.remove(at: indexPath.row)
         if getRecipe.recipeIngredientArray.count == 0 {
            ingredientViewTopConstraint.constant = -2
            addIngredientButtonTopConstraint.constant = 23
            addIngredientTableViewHeightConstraint.constant = 1
        } else {
            addIngredientTableView.reloadData()
        }
    }

     //Mark: - Remove Step
     @objc func removeStepButtonAction(_ sender: Any) {
        let button = sender as? UIButton
        let cell1 = button?.superview?.superview as? AddStepTableViewCell
        let indexPath = addStepTableView.indexPath(for: cell1!)!
        getRecipe.recipeAddStepArray.remove(at: indexPath.row)
        if getRecipe.recipeAddStepArray.count == 0 {
            stepViewTopConstraint.constant = -2
            addStepButtonTopConstraint.constant = 23
            addStepTableViewHeightConstraint.constant = 1
        } else {
            addStepTableView.reloadData()
        }
    }

     func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        editRecipeScrollView.isScrollEnabled = false
       let addStep = getRecipe.recipeAddStepArray[indexPath.row]
        getRecipe.recipeAddStepArray.remove(at: indexPath.row)

        getRecipe.recipeAddStepArray.insert(addStep, at: newIndexPath.row)
        addStepTableView.moveRow(at: indexPath, to: newIndexPath)
        addStepTableView.isScrollEnabled = false
        addStepTableView.reloadData()
        editRecipeScrollView.isScrollEnabled = true
        return true
    }
}
