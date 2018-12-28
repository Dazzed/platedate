//
//  UIColor.swift
//  PlateDate
//
//  Created by WebCrafters on 01/12/18..
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

    extension UIColor {
        static let _lightningYellow = UIColor("#FEA736")
        static let _ghostWhite = UIColor("#F8F8FC")
        static let _gainsBoro = UIColor("#D9D9D9")
        static let _darkGray = UIColor("#A9A9A9")
        static let _noble = UIColor("#999999")
        static let _lightGray = UIColor("#ECECEC")
        static let _lightGray1 = UIColor("#E9E9E9")
        static let _lightGray2 = UIColor("#B7B7B7")
        static let _lightGrayShadow = UIColor("#CDCAC2")
         static let _lightGray3 = UIColor("#4D4D4D")

        //Ref
        static let _lightGray4 = UIColor("#808080")
    }

extension UIColor {
    convenience init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
