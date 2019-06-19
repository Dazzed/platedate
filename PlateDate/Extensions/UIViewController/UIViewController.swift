//
//  UIViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 01/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

extension UIViewController {

    //MARK: - navigationPush Redirect Page
    func navigationPushRedirect(storyBoardName:String, storyBoardId:String) {
        let secondViewController = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: storyBoardId)
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

      //MARK: - navigationPush Redirect Page Auto login
    func navigationPushAutoRedirect(storyBoardName:String, storyBoardId:String) {
        let secondViewController = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: storyBoardId)
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }

    //MARK: - Redirect Page
    func redirect(storyBoardName:String, storyBoardId:String) {
        let controller = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: storyBoardId)
        present(controller, animated: true, completion: nil)
    }

    //MARK: - NavigationBar Hide
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    //MARK: - NavigationBar Show
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK: - Alert
    func alert(title:String, message:String, cancel:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

     // MARK: - EMAIL
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

     //MARK: - TableView Height
    func tableViewHeight(tableView:UITableView, height: CGFloat) -> CGFloat {
        var tableHeight:CGFloat!
        let width = UIScreen.main.bounds.size.width
        tableHeight = (width/640) * height
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.tableHeaderView!.frame.size.width, height: tableHeight)
        return tableHeight
    }

    //Mark: - Random Generate OTP Number
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }

     // MARK: - Random String for Username and Password (username and password for must be needed for user generation in Parse)
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }

    //MARK: - Calculate Time
    func currentTime(time:String) ->String {
        let time = moment(time, "YYYY-MM-DD hh:mm:ss")
        return time.fromNow()
    }

     func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
