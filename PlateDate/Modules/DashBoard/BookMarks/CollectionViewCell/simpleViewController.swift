//
//  simpleViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 06/03/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit
import Alamofire

typealias MutipleValue = (totalWeight: Double, nutritionInfo: [String:AnyObject])

class simpleViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var simple: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var myDictionary = [String: Any]()
    var NutritionDictionary = [String: NutritionValue]()
    var calculateWeight:Double = 0.0
     var nutritionFacts = [String: Double]()

    @IBOutlet weak var textfielddd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        textfielddd.delegate = self
        keyBoardNotification()
     //   getNutritionValues()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // in half a second...
                //self.storeValues()
            }
      //  simple.frame = CGRect(x:simple.frame.origin.x,y:simple.frame.origin.y,width:simple.frame.width,height:200)
      //simple.contentSize.height = 2500
     // bottomConstraint.constant = bottomConstraint.constant + 500
        // Do any additional setup after loading the view.
    }

//    func getNutritionValues() {
//        let ingredientAmountArray = ["20ml", "1", "20 ml"]
//        let ingredientArray = ["milk", "large apple", "water"]
//       //  let url : String = "&ingr=\(ingredientAmountArray[i]) \(index)"
//        for i in 0 ..< ingredientArray.count {
//            let url = "https://api.edamam.com/api/nutrition-data?&app_id=e554574a&app_key=accaf9ed827ac7499e886c4b817df065"
//            let runLoop = CFRunLoopGetCurrent()
//            Alamofire.request(url, parameters: ["ingr": "\(ingredientAmountArray[i]) \(ingredientArray[i])"]).responseJSON { response in
//                print("Finished request \(i)")
//                let dictionary = response.result.value as?[String:AnyObject]
//                let totalNutirion = dictionary!["totalNutrients"] as?[String:AnyObject]
//                let weight = dictionary!["totalWeight"] as! Double
//                 NutritionFactsArray.nutritionFacts.append(NutritionFacts(ingredientName: ingredientArray[i], ingredientAmount: ingredientAmountArray[i], totalWeight: weight, nutirionInformarion: totalNutirion!))
//                self.NutritionDictionary["\(ingredientAmountArray[i]) \(ingredientArray[i])"] = MutipleValue(totalWeight: weight, nutritionInfo: totalNutirion!)
//                CFRunLoopStop(runLoop)
//            }
//            CFRunLoopRun()
//        }
//    }


    //    func calulatePercentage() {
//        var _:Double = 0.0
//        var totalPercentage:Double = 0.0
//        for (key, _) in nutritionFacts {
//            // print((nutritionFacts[key]! / (calculateWeight * 1000)) * 100)
//            let percentage = (nutritionFacts[key]! / (calculateWeight * 1000)) * 100
//             print("\(key)  (\(percentage)")
//            nutritionFacts.updateValue(percentage, forKey: key)
//            //self.nutritionFacts[value["label"] as! String] = percentage
//             totalPercentage = totalPercentage + percentage
//        }
//        print(nutritionFacts)
//    }



//        for (i,index) in ingredientArray.enumerated() {
//                print(index)
//            let url : String = "https://api.edamam.com/api/nutrition-data?&app_id=e554574a&app_key=accaf9ed827ac7499e886c4b817df065&ingr=\(ingredientAmountArray[i]) \(index)"
//            let urlStr : String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            let convertedURL : URL = URL(string: urlStr)!
//            Alamofire.request(convertedURL, method: .get, parameters:nil, encoding: JSONEncoding.default).responseJSON { response in
//                let dictionary = response.result.value as?[String:AnyObject]
//                let weight = dictionary!["totalWeight"] as! Double
//                //self.calculateWeight = self.calculateWeight + weight
//                let totalNutirion = dictionary!["totalNutrients"] as?[String:AnyObject]
//                NutritionFactsArray.nutritionFacts.append(NutritionFacts(ingredientName: index, ingredientAmount: ingredientAmountArray[i], totalWeight: weight, nutirionInformarion: totalNutirion!))
//            }
//        }




//    func getValues() {
//        var convert:Double = 0.0
//        let array = ["20ml milk", "1 large apple", "20 ml water"]
//        for (_,index) in array.enumerated() {
//                print(index)
//            let url : String = "https://api.edamam.com/api/nutrition-data?&app_id=e554574a&app_key=accaf9ed827ac7499e886c4b817df065&ingr=\(index)"
//            let urlStr : String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            let convertedURL : URL = URL(string: urlStr)!
//            Alamofire.request(convertedURL, method: .get, parameters:nil, encoding: JSONEncoding.default).responseJSON { response in
//                let dictionary = response.result.value as?[String:AnyObject]
//                let weight = dictionary!["totalWeight"] as! Double
//                self.calculateWeight = self.calculateWeight + weight
//                let totalNutirion = dictionary!["totalNutrients"] as?[String:AnyObject]
//                for (_, value) in totalNutirion!{
//                    print(value["label"])
//
//                    if value["label"] as! String != "Energy" {
//                         if value["unit"] as! String == "g" {
//                            convert =  value["quantity"] as! Double
//                            convert = convert * 1000
//                        } else if value["unit"] as! String == "mg" {
//                            convert =  value["quantity"] as! Double
//                        } else if value["unit"] as! String == "µg" {
//                            convert =  value["quantity"] as! Double
//                            convert = convert * 0.001
//                        }
//
//                        if self.myDictionary[value["label"] as! String] != nil {
//                           self.myDictionary[value["label"] as! String] = (self.myDictionary[value["label"] as! String])! + convert
//                          //  data.updateValue(newValue, forKey: self.myDictionary[value["label"] as! String])
//                        } else {
//                            self.myDictionary[value["label"] as! String] = convert
//                        }
//                    }
//                }
//            }
//            self.calulatePercentage()
//        }
//    }

//    func calulatePercentage() {
//        var _:Double = 0.0
//        var totalPercentage:Double = 0.0
//        for (key, value) in myDictionary {
//            // print((myDictionary[key]! / (calculateWeight * 1000)) * 100)
//        let percentage = (myDictionary[key]! / (calculateWeight * 1000)) * 100
//             print("\(key)  (\(percentage)")
//            myDictionary.updateValue(percentage, forKey: key)
//            //self.myDictionary[value["label"] as! String] = percentage
//             totalPercentage = totalPercentage + percentage
//        }
//        print(myDictionary)
//    }



//    func getValues1() {
//        var myDictionary = [String: Double]()
//        let totalNutriant:Double = 0.0
//        let array = ["20ml milk"]
//        var totalQuantiy:Double = 0.0
//        var totalPercentage:Double = 0.0
//        for (_,index) in array.enumerated() {
//            let url : String = "https://api.edamam.com/api/nutrition-data?&app_id=e554574a&app_key=accaf9ed827ac7499e886c4b817df065&ingr=\(index)"
//            let urlStr : String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            let convertedURL : URL = URL(string: urlStr)!
//            Alamofire.request(convertedURL, method: .get, parameters:nil, encoding: JSONEncoding.default).responseJSON { response in
//                let dictionary = response.result.value as?[String:AnyObject]
//                let totalWeight = dictionary!["totalWeight"] as! Double
//                let totalNutirion = dictionary!["totalNutrients"] as?[String:AnyObject]
//                for (_,value) in totalNutirion!{
//                    let percentage = (value["quantity"] as! Double / totalWeight) * 100
//                    totalPercentage = totalPercentage + percentage
//                    if value["label"] as! String != "Energy" {
//                        if myDictionary[value["label"] as! String] != nil {
//                            myDictionary[value["label"] as! String] = (myDictionary[value["label"] as! String])! + percentage
//                            totalQuantiy = value["quantity"] as! Double  + totalQuantiy
//                        } else {
//                            myDictionary[value["label"] as! String] = percentage
//                            totalQuantiy = value["quantity"] as! Double + totalQuantiy
//                        }
//                    }
//                }
//                print(totalPercentage)
//                print(totalQuantiy)
//                 print(myDictionary)
//            }
//        }
//    }

    func totalCalculate() {
//           if value["label"] as! String != "ENERC_KCAL" {
//
//                        if value["unit"] as! String == "g" {
//                            var covert =  value["quantity"] as! Double
//                            covert = covert * 1000
//                            totalNutriant = totalNutriant + covert
//                            print(totalNutriant)
//                        } else if value["unit"] as! String == "mg" {
//                            let covert =  value["quantity"] as! Double
//                            totalNutriant = totalNutriant + covert
//                            print(totalNutriant)
//                        } else if value["unit"] as! String == "µg" {
//                             var covert =  value["quantity"] as! Double
//                            covert = covert * 0.001
//                            totalNutriant = totalNutriant + covert
//                            print(totalNutriant)
//                        }
//                    } else {
//                        print("It is energy")
//                    }
    }


     // Mark: - Keyboard Notification
    func keyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(simpleViewController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(simpleViewController.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    // Mark: - Keyboard Show Notification
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
                   // self.view.frame.origin.y -= keyboardSize.height
                   print(keyboardSize.height)
                   bottomConstraint.constant =  10
        }
    }

    // Mark: - Keyboard Hide Notification
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            bottomConstraint.constant = 0
                //self.view.frame.origin.y += keyboardSize.height
        }
    }
}






 
