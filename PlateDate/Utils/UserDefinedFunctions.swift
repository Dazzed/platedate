//
//  UserDefinedFunctions.swift
//  PlateDate
//
//  Created by WebCrafters on 31/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import Parse
import Alamofire

extension UIViewController {
    func login() {
        UserDefaults.standard.set(true, forKey: "login")
        UserDefaults.standard.set(PFUser.current()?.objectId, forKey: "userId")
        if User.firstLogin == true {
            self.navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.profileInfo, storyBoardId: ViewController.StoryBoardId.slideStoryBoardId)
        } else {
             navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.dashBaord, storyBoardId: TabBar.tabBarStoryBoardId)
        }
    }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
