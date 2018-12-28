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
}

