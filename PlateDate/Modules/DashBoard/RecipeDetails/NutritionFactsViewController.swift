//
//  NutritionFactsViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 22/03/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

typealias NutritionValue = (quantity: Double, Unit:String, percentage: Double)


class NutritionFactsViewController: UIViewController {

    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var nutritionFactsTableView: UITableView!
    var myDictionary = [String: Any]()
    var calculateWeight:Double = 0.0
    var NutritionDictionary = [String: NutritionValue]()
    var totalQuantity = [Double]()
    var totalCalories:Double = 0.0
    var unit = [String]()
    var nutritionNameArray = [String]()
    var nutritionquantityArray = [String]()
    var nutritionperCentageArray = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getNutritionFacts()
        addCookWareReuseIdentifier()
    }

    func addCookWareReuseIdentifier() {
        nutritionFactsTableView.dataSource = self
        nutritionFactsTableView.delegate = self
         nutritionFactsTableView.register(UINib(nibName: "NutritionFactsTableViewCell", bundle: nil), forCellReuseIdentifier:  "NutritionCell")
        nutritionFactsTableView.backgroundColor = .clear
        nutritionFactsTableView.separatorStyle = .none
    }

    func getNutritionFacts() {
        var convert:Double = 0.0
        for nutrition in RecipeDetail.nutritionFacts {
            let totalNutirion = nutrition["totalNutrients"] as?[String:AnyObject]
            let weight = nutrition["totalWeight"] as! Double
            let calories = nutrition["calories"] as! Double
            calculateWeight = calculateWeight + weight
             print(calories)
            totalCalories = totalCalories + calories
            print(totalCalories)

            for (_, value) in totalNutirion! {
                if value["label"] as! String != "Energy" {
                    if value["unit"] as! String == "g" {
                        convert =  value["quantity"] as! Double
                       // convert = convert * 1000
                        convert = convert * 0.001
                    } else if value["unit"] as! String == "mg" {
                        convert =  value["quantity"] as! Double
                    } else if value["unit"] as! String == "µg" {
                        convert =  value["quantity"] as! Double
                        convert = convert * 1000
                       // convert = convert * 0.001
                    }
                    if self.myDictionary[value["label"] as! String] != nil {
                        self.myDictionary[value["label"] as! String] = (self.myDictionary[value["label"] as! String])! as! Double + convert
                    } else {
                        self.myDictionary[value["label"] as! String] = convert
                    }
                }
            }
        }
        calulatePercentage()
    }

    func calulatePercentage() {
        totalCaloriesLabel.text = "String\(totalCalories) g"
        var _:Double = 0.0
        var totalPercentage:Double = 0.0
        for (key, _) in myDictionary {
            let quantity = myDictionary[key]! as! Double
            var covertQuantity:String = ""
            if  quantity > 1000 {
                print("g")
            let round = (String(format: "%.2f", ceil(quantity)))
            //String(format: "%.2f", quantity * 1000)
                covertQuantity = "\(String(format: "%.2f",(quantity / 1000)))g"
                 print(covertQuantity)
            } else if quantity < 1 {
                let round = (String(format: "%.2f", ceil(quantity*1000)))
                covertQuantity = "\(String(format: "%.2f",quantity))µg"
                 print(covertQuantity)
            } else {
                let round = (String(format: "%.2f", ceil(quantity*1000)))
                covertQuantity = "\(String(format: "%.2f",quantity))mg"
                 print(covertQuantity)
            }


            let round1 = 104550

            print(" local local \(("%.2f", round1)))")




            //print("covertQuantitycovertQuantitycovertQuantity\(covertQuantity)")

            var percentage = ((myDictionary[key]! as! Double / (calculateWeight * 1000)) * 100).rounded(toPlaces:  2)
            totalCaloriesLabel.text = String(totalCalories)
            myDictionary.updateValue(percentage, forKey: key)
            totalPercentage = totalPercentage + percentage
            nutritionNameArray.append(key)

            if covertQuantity == "0.0g" {
                covertQuantity = "0.1g"
            }

            if covertQuantity == "0.0µg" {
                covertQuantity = "0.1µg"
            }

            if percentage == 0.0 {
                percentage = 0.1
            }
            nutritionquantityArray.append(covertQuantity)
            nutritionperCentageArray.append(percentage)
        }
    }

     // Mark: - Back Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension NutritionFactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionNameArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nutritionFactsTableView.dequeueReusableCell(withIdentifier:  "NutritionCell") as! NutritionFactsTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.nutritionNameLabel.text = nutritionNameArray[indexPath.row]
        cell.nutritionAmountLabel.text = nutritionquantityArray[indexPath.row]
        cell.nutritionPercentage.text = "\(nutritionperCentageArray[indexPath.row])%"
        return cell
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
