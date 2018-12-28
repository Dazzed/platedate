//
//  User.swift
//  PlateDate
//
//  Created by WebCrafters on 03/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

struct  User {
    struct Facebook {
        static var authToken = ""
        static var email = ""
        static var name = ""
        static var location = ""
        static var imageUrl = ""
        static var gender = ""
         static var verified:Bool = false 
    }

    static var message = ""
    static var mobile = ""
    static var id = 0
    static var email = ""
    static var name = ""
    static var location = ""
    static var imageUrl = ""
    static var gender = ""
    static var emailVerified:Bool = false
     static var mobileVerified:Bool = false
}
