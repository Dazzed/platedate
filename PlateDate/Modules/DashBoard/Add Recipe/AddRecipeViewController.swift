//
//  AddRecipeViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 06/01/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import ImagePicker
import EasyPopUp
import Photos
import TableViewDragger
import Parse
import Alamofire



class AddRecipeViewController: UIViewController, ImagePickerDelegate, UITextViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate, UIGestureRecognizerDelegate {

    //Mark: - @IBOutlets
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeModeSwitch: UISwitch!
    @IBOutlet var imageRemoveButton: UIButton!
    @IBOutlet var recipeTitleView: UIView!
    @IBOutlet var recipeDescriptionView: UIView!
    @IBOutlet var descriptionTextView: MultilineTextField!
    @IBOutlet var recipeTitleTextView: MultilineTextField!
    @IBOutlet var servingsTextField: UITextField!
    @IBOutlet var privateLabel: UILabel!
    @IBOutlet var imageIconView: UIView!
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var shadowImageView: UIImageView!
    @IBOutlet var editAction: UIButton!
    @IBOutlet var addRecipeTopView: UIView!
    @IBOutlet weak var recipeTitleCharacterCountLabel: UILabel!
    @IBOutlet weak var recipeDescriptionCahracterCountLabel: UILabel!
    @IBOutlet weak var addStepCharacterCountLabel: UILabel!

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
    @IBOutlet var uploadSuccessPopUPView: UIView!
    @IBOutlet var addRecipeScrollView: UIScrollView!
    @IBOutlet weak var ingredientErrorLabel: UILabel!
    @IBOutlet weak var successMessageLabel: UILabel!

    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinnerImageView: UIImageView!

    var convertMins:String = ""

    //Mark: - @Declaration
    var popUpConfig = EasyPopupConfig()
    var updateTime:Double = 0
    var addCookWareArray = [String]()
    var addIngredientNameArray = [String]()
    var addIngredientAmountArray = [String]()
    var addStepArray = [String]()
    var recipeImage = UIImage()
    let screenSize = UIScreen.main.bounds
    var editCellBool:Bool = false
    var cellIndex:Int = 0
    var dragger: TableViewDragger!

    var nutirion = [[String:AnyObject]]()
    //var a = [[{}]]

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

     //Mark: - UploadSuccess
    lazy var uploadSuccessPopUp : EasyPopup = {
        let easePopUp = EasyPopup(superView: self.view, viewTopop: uploadSuccessPopUPView)
         popUpConfig.animationType = .scale
         popUpConfig.animaionDuration = 0.3
        return easePopUp
    }()





    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        timePickerPopUp()
        tapGustureRecognizer()
        delegates()
        addCookWareReuseIdentifier() 
        addIngredientResueIdentifier()
        addStepResueIdentifier()
        draggerTableView()
        setupLongPressGesture()
        recipeImageView.clipsToBounds = true
        hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.isHidden = false
        LoadSpinnerView()
    }

     func LoadSpinnerView() {
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        spinnerView.isOpaque = false
        spinnerImageView.image = UIImage.gif(name: "Spinner")
        spinnerView.isHidden = true
    }

     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.current()?.objectId == nil {
            print("Success")
        }

    }

    //Mark: - Reorder TableView
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5 // 1 second press
        longPressGesture.delegate = self
        addStepTableView.addGestureRecognizer(longPressGesture)
    }

    //Mark: - Handle Long Press
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            addRecipeScrollView.isScrollEnabled = false
        } else if gestureRecognizer.state == .ended {
            addRecipeScrollView.isScrollEnabled = true
        }
    }

      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
         if AddRecipe.uploadSuccessBool == true {
            AddRecipe.uploadSuccessBool = false
            self.uploadSuccessPopUp.removePopup()
            self.navigationController?.navigationBar.isHidden = true
            removeAll()
         }

         self.spinnerView.isHidden = true
    }

    //Mark: - Dragger TableView
    func draggerTableView() {
        dragger = TableViewDragger(tableView: addStepTableView)
        dragger.dataSource = self
        dragger.delegate = self
        dragger.alphaForCell = 0.7
        addStepTableView.reloadData()
    }

    //Mark: - Time Picker PopUp Width
    func popUPWidth() {
        timePickerPopupView.frame = CGRect(x:timePickerPopupView.frame.origin.x, y:timePickerPopupView.frame.origin.y,  width:screenSize.width, height:timePickerPopupView.frame.height)
        addCookWarePopUpView.frame = CGRect(x:addCookWarePopUpView.frame.origin.x, y:addCookWarePopUpView.frame.origin.y,  width:screenSize.width, height:addCookWarePopUpView.frame.height)
        addIngredientView.frame = CGRect(x:addIngredientView.frame.origin.x, y:addIngredientView.frame.origin.y,  width:screenSize.width, height:addIngredientView.frame.height)
        addStepPopUpView.frame = CGRect(x:addStepPopUpView.frame.origin.x, y:addStepPopUpView.frame.origin.y,  width:screenSize.width, height:addStepPopUpView.frame.height)
    }

    //Mark: - Delete Button Action
    @IBAction func editButtonAction(_ sender: Any) {
         navigationPushRedirect(storyBoardName: "AddRecipe", storyBoardId: "EditRecipe")
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
        addCookWareTableView.reloadData()
    }

     //Mark: - AddIngredient ReuseIdentifier
    func addIngredientResueIdentifier() {
        addIngredientTableView.delegate = self
        addIngredientTableView.dataSource = self
        addIngredientTableView.separatorStyle = .none
        addIngredientTableView.register(UINib(nibName: TableViewCell.ClassName.addIngredient, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.addIngredient)
        addIngredientTableView.reloadData()
    }

    //Mark: - AddStep ReuseIdentifier
    func addStepResueIdentifier() {
        addStepTableView.delegate = self
        addStepTableView.dataSource = self
        addStepTableView.separatorStyle = .none
        addStepTableView.register(UINib(nibName: TableViewCell.ClassName.addStep, bundle: nil), forCellReuseIdentifier:  TableViewCell.ReuseIdentifier.addStep)
        addStepTableView.reloadData()
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



    //Mark: - TextView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == recipeTitleTextView {
            if range.location == 0 {
                let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            } else {
                if(textView.text.count > 49) {
                    print("Please summarize in 50 characters or less")
                    return false      
                }
            }

        }

        if textView == descriptionTextView {
            if range.location == 0 {
                let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            } else {
                if(textView.text.count > 299) {
                    return false
                }
            }
        }

         if textView == addStepTextView {
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

        if textField == servingsTextField {
            if range.location == 0 {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
            }
        }
        return true
    }
    
     //Mark: - TapGustureRecognizer for View click Function
    func tapGustureRecognizer() {
        let timeNeededViewtap = UITapGestureRecognizer(target: self, action: #selector(AddRecipeViewController.timePickerPopUP))
        timeNeededView.addGestureRecognizer(timeNeededViewtap)
    }

    //Mark: - Change Private and publish mode
    @IBAction func switchChangeAction(_ sender: UISwitch) {
        if sender.isOn {
            AddRecipe.recipeMode = "0"
            privateLabel.text = "I want this recipe to be Published"
            uploadButton.setImage(#imageLiteral(resourceName: "upload_orange"), for: .normal)
            successMessageLabel.text = "Your recipe has been published"
        } else {
            privateLabel.text = "I want this recipe to be Private"
            AddRecipe.recipeMode = "1"
            uploadButton.setImage(#imageLiteral(resourceName: "upload - black"), for: .normal)
            successMessageLabel.text = "Your private recipe has been uploaded"
        }
    }

    //Mark: - Get image from Gallery
    @IBAction func imgaePickerButtonAction(_ sender: Any) {
        print("button working.....")
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
                addCookWareArray.append(addCookWare)
                addCookWareTableView.reloadData()
                addCookWarePopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addCookWareTextField.text = ""
                }
            } else {
                addCookWareTextField.becomeFirstResponder()
                addCookWareArray[cellIndex] =  self.addCookWareTextField.text!
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
        if addIngredientName.isEmpty || addIngredientAmount.isEmpty {
            print("error")
        } else {
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
                addStepArray.append(addstep)
                self.addStepTableView.reloadData()
                addStepPopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addStepTextView.text = ""
                }
            } else {
                addStepArray[self.cellIndex] = self.addStepTextView.text
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
        addRecipeValues()
        if AddRecipe.recipeMode == "1" {
            addRecipeAPI()
        } else {
             requireFieldsAPI()
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
                    self.addIngredientNameArray.append(ingredientName)
                    self.addIngredientAmountArray.append(ingredientAmount)
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
                    self.addIngredientNameArray[index] =  self.addIngredientNameTextField.text!
                    self.addIngredientAmountArray[index] =  self.addIngredientAmountTextField.text!
                    self.addIngredientTableView.reloadData()
                    self.addIngredientPopUp.removePopup { (isfinished) in
                    print(isfinished)
                    self.addIngredientNameTextField.text = ""
                    self.addIngredientAmountTextField.text = ""
                }
            }
        }
    }

    //Mark: - AddRecipe details
    func addRecipeValues() {
        AddRecipe.recipeTitle = recipeTitleTextView.text!.trimmingCharacters(in: .whitespaces)
        AddRecipe.recipeDescription = descriptionTextView.text!.trimmingCharacters(in: .whitespaces)
        AddRecipe.servings = servingsTextField.text!
        AddRecipe.prepatationTime = timeTextField.text!
        AddRecipe.recipeCookWareArray = addCookWareArray
        AddRecipe.recipeIngredientArray = addIngredientNameArray
        AddRecipe.recipeIngredientAmountArray = addIngredientAmountArray
        AddRecipe.recipeAddStepArray = addStepArray
    }

    //Mark: - AddRecipe API
    func addRecipeAPI() {
        spinnerView.isHidden = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        let user = PFUser.current()
        let uploadRecipe = PFObject(className:"Recipe")
        uploadRecipe["relationKey"] = user
        uploadRecipe["relationKey"] = PFUser(withoutDataWithClassName:"_User", objectId:(PFUser.current()?.objectId!))

        uploadRecipe["recipeMode"] = AddRecipe.recipeMode

        if recipeTitleTextView.text != nil {
            uploadRecipe["recipeTitle"] = AddRecipe.recipeTitle
        }

         if descriptionTextView.text != nil {
            uploadRecipe["recipeDescription"] = AddRecipe.recipeDescription
        }

         if servingsTextField.text != nil {
             uploadRecipe["servings"] = AddRecipe.servings
        }

        if timeTextField.text != nil {
            print(AddRecipe.prepatationTime)
            uploadRecipe["preparationTime"] = AddRecipe.prepatationTime
        }

        if AddRecipe.recipeCookWareArray.count != 0 {
             uploadRecipe["recipeCookWare"] = AddRecipe.recipeCookWareArray
             uploadRecipe["nutritionFacts"] = nutirion
        }

         if AddRecipe.recipeIngredientArray.count != 0 {
            uploadRecipe["recipeIngredient"] = AddRecipe.recipeIngredientArray
        }

         if AddRecipe.recipeIngredientAmountArray.count != 0 {
            uploadRecipe["recipeIngredientAmount"] = AddRecipe.recipeIngredientAmountArray
        }

        if AddRecipe.recipeAddStepArray.count != 0 {
            uploadRecipe["recipeAddStep"] = AddRecipe.recipeAddStepArray
        }

        //Mark : - Save Image
        if recipeImageView.image != nil {
            let imageData = UIImageJPEGRepresentation(recipeImageView.image!, 0.5)
            let imageFile = PFFileObject(name:"avatar.jpg", data:imageData!)
            uploadRecipe["recipeImage"] = imageFile
        }

        //Mark : - Upload Recipe
        uploadRecipe.saveInBackground(block: { (success, error) in
            if error == nil {
                self.spinnerView.isHidden = true
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                self.uploadSuccessPopUp.showPopup { (isfinished) in
                    print(isfinished)
                    self.removeAll()
                }
           } else {
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                print("Failed")
        }
        })
    }

    func retriveRecipe() {
        let query = PFQuery(className:"Recipe")
        query.includeKey("relationKey")
        query.whereKey("relationKey", equalTo: PFUser.current()!)
        query.order(byDescending: "createdAt")
        query.limit = 1
        query.findObjectsInBackground(block: { (recipes: [PFObject]?, error: Error?) in
            if let error = error {
                // There was an error
                print("error.localizedDescription\(error.localizedDescription)")
            } else {
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
                    
                ProfilleRecipeArray.profileRecipeDisplay.insert((ProfileRecipe(recipeObjectId: recipe.objectId!, recipeTitle:  recipe["recipeTitle"] as! String, recipeDescription: recipe["recipeDescription"] as! String, recipeCreateTime: String(describing: recipe.createdAt), recipeImageUrl: recipeImageUrl, recipeUserName: user["userDisplayName"] as! String, bookMark: DashBoardArray.bookMarkString, recipeUserobjectId: user.objectId!, recipeMode: recipe["recipeMode"] as! String, recipeUserImageUrl: recipeUserImageUrl)), at: 0)
                    self.uploadSuccessPopUp.config = self.popUpConfig
                    self.uploadSuccessPopUp.showPopup { (isfinished) in
                        print(isfinished)
                        self.popupRemove()

                    }
                }
            }
        })
    }

    func popupRemove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
             AddRecipe.uploadSuccessBool = true
             self.removeAll()
             self.uploadSuccessPopUp.removePopup()
        }
    }

    func removeAll() {
        imageRemoveButton.isHidden = true
        recipeImageView.image = nil
        imageIconView.isHidden = false
        recipeModeSwitch.isOn = false
        recipeTitleTextView.text = ""
        descriptionTextView.text = ""
        timeTextField.text = ""
        servingsTextField.text = ""
        uploadButton.setImage(#imageLiteral(resourceName: "upload - black"), for: .normal)
        addCookWareArray.removeAll()
        addIngredientAmountArray.removeAll()
        addIngredientNameArray.removeAll()
        addStepArray.removeAll()

        addIngredientTableViewHeightConstraint.constant = 1
        cookwareViewTopConstraint.constant = 0
        addCookWareTableViewHeightConstraint.constant = 1

        ingredientViewTopConstraint.constant = 0
        addIngredientTableViewHeightConstraint.constant = 1

        stepViewTopConstraint.constant = 0
        addStepTableViewHeightConstraint.constant = 1

        addCookWareTableView.reloadData()
        addIngredientTableView.reloadData()
        addStepTableView.reloadData()
    }


    //Mark : - RequireFields for Public API
    func requireFieldsAPI() {
        if recipeImageView.image == nil || AddRecipe.recipeTitle.isEmpty || AddRecipe.recipeDescription.isEmpty || AddRecipe.prepatationTime.isEmpty || AddRecipe.servings.isEmpty ||  AddRecipe.recipeCookWareArray.count == 0 ||  AddRecipe.recipeIngredientArray.count == 0 ||  AddRecipe.recipeAddStepArray.count == 0  {
            errorPopUp.config = popUpConfig
            errorPopUp.showPopup { (isfinished) in
                print(isfinished)
            }
        } else {
            addRecipeAPI()
        }
    }

     @IBAction func errorDismissButtonAction(_ sender: Any) {
        errorPopUp.removePopup { (isfinished) in
            print(isfinished)
        }
    }
}

extension AddRecipeViewController: UITableViewDelegate, UITableViewDataSource, TableViewDraggerDataSource, TableViewDraggerDelegate {
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
            AddRecipe.filePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("png").absoluteString
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
             return addCookWareArray.count
         } else if tableView == addIngredientTableView {
             return addIngredientNameArray.count
        } else {
            return addStepArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        addRecipeScrollView.isScrollEnabled = true
        addStepTableView.isScrollEnabled = false
        if tableView == addCookWareTableView {
            let cell = addCookWareTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.addCookWare) as! AddCookWareTableViewCell
             cell.selectionStyle = .none
             cell.addCookWareCancelButton.tag = indexPath.row
             cell.addCookWareCancelButton.addTarget(self, action: #selector(removeCookwareButtonAction), for: .touchUpInside)
             cell.addCookWareLabel.text = addCookWareArray[indexPath.row]
             cookwareViewTopConstraint.constant = 23
             addCookWareTableViewHeightConstraint.constant = addCookWareTableView.contentSize.height + 10
            return cell
        } else if tableView == addIngredientTableView {
             let cell = addIngredientTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.addIngredient) as! AddIngredientTableViewCell
              cell.selectionStyle = .none

              cell.addIngredientNameLabel.text = "\(addIngredientAmountArray[indexPath.row]) \(addIngredientNameArray[indexPath.row])"
              ingredientViewTopConstraint.constant = 23
              addIngredientTableViewHeightConstraint.constant = addIngredientTableView.contentSize.height + 10

              cell.removeIngredientButton.addTarget(self, action: #selector(removeIngredientButtonAction), for: .touchUpInside)
             return cell
        } else {
            let cell = addStepTableView.dequeueReusableCell(withIdentifier:  TableViewCell.ReuseIdentifier.addStep) as! AddStepTableViewCell
            cell.selectionStyle = .none
            cell.addStepLabel.text = addStepArray[indexPath.row]
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
                self.addStepTextView.text = self.addStepArray[indexPath.row]
                self.editCellBool = true
                self.cellIndex = indexPath.row
            }
        } else if tableView == addIngredientTableView {
            let indexPath = addIngredientTableView.indexPathForSelectedRow!
            addIngredientPopUp.config = popUpConfig
            addIngredientPopUp.showPopup { (isfinished) in
                print(isfinished)
                self.addIngredientNameTextField.becomeFirstResponder()
                self.addIngredientNameTextField.text = self.addIngredientNameArray[indexPath.row]
                if self.addIngredientAmountArray[indexPath.row] == "-" {
                    self.addIngredientAmountTextField.text = ""
                } else {
                    self.addIngredientAmountTextField.text = self.addIngredientAmountArray[indexPath.row]
                }
                self.editCellBool = true
                self.cellIndex = indexPath.row
            }
        } else {
                let indexPath = addCookWareTableView.indexPathForSelectedRow!
                addCookWarePopUp.config = popUpConfig
                addCookWarePopUp.showPopup { (isfinished) in
                print(isfinished)
                self.addCookWareTextField.becomeFirstResponder()
                self.addCookWareTextField.text = self.addCookWareArray[indexPath.row]
                self.editCellBool = true
                self.cellIndex = indexPath.row
            }
        }
    }

      //Mark: - Remove Cookware
      @objc func removeCookwareButtonAction(_ sender: Any) {
        let button = sender as? UIButton
        let cell1 = button?.superview?.superview as? AddCookWareTableViewCell
        let indexPath = addCookWareTableView.indexPath(for: cell1!)
        addCookWareArray.remove(at: (indexPath?.row)!)
        if addCookWareArray.count == 0 {
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
        let indexPath = addIngredientTableView.indexPath(for: cell1!)
        addIngredientNameArray.remove(at: (indexPath?.row)!)
        addIngredientAmountArray.remove(at: (indexPath?.row)!)
        nutirion.remove(at: (indexPath?.row)!)
         if addIngredientNameArray.count == 0 {
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
        let cell = button?.superview?.superview as? AddStepTableViewCell
        let indexPath = addStepTableView.indexPath(for: cell!)
        addStepArray.remove(at: (indexPath?.row)!)
        if addStepArray.count == 0 {
            stepViewTopConstraint.constant = -2
            addStepButtonTopConstraint.constant = 23
            addStepTableViewHeightConstraint.constant = 1
        } else {
            addStepTableView.reloadData()
        }
    }

    //Mark: - Reorder Row in TableView ArrayArray
      func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        addRecipeScrollView.isScrollEnabled = false
       let addStep = addStepArray[indexPath.row]
        addStepArray.remove(at:  indexPath.row)
        addStepArray.insert(addStep, at: newIndexPath.row)
        addStepTableView.moveRow(at: indexPath, to: newIndexPath)
        addStepTableView.isScrollEnabled = false
        addStepTableView.reloadData()
        addRecipeScrollView.isScrollEnabled = true
        return true
    }
}
