//
//  BottomBorderTextField.swift
//  PlateDate
//
//  Created by WebCrafters on 06/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

final class BottomBorderTextField: UITextField {

    // MARK: - TextField's life cycle
      override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }

     // MARK: - YellowBorder
     func yellowBorderTextField() {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 2.0

        let borderLine = UIView(frame: CGRect(x:0, y:self.frame.height - CGFloat(width), width:self.frame.width, height:CGFloat(width)))
        borderLine.backgroundColor = UIColor._lightningYellow
        self.addSubview(borderLine)
    }

    //MARK: - Clear Border
     func clearBorderTextField() {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 2.0

        let borderLine = UIView(frame: CGRect(x:0, y:self.frame.height - CGFloat(width), width:self.frame.width, height:CGFloat(width)))
        borderLine.backgroundColor = UIColor.white
        self.addSubview(borderLine)
    }

    //MARK: - Grey Border
     func greyBorderTextField() {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 2.0

        let borderLine = UIView(frame: CGRect(x:0, y:self.frame.height - CGFloat(width), width:self.frame.width, height:CGFloat(width)))
        borderLine.backgroundColor = UIColor._lightGray3 
        self.addSubview(borderLine)
    }

    override func deleteBackward() {
        super.deleteBackward()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deletePressed"), object: nil)
    }

     // MARK: - Main
    private func setupTextField() {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 2.0

        let borderLine = UIView(frame: CGRect(x:0, y:self.frame.height - CGFloat(width), width:self.frame.width, height:CGFloat(width)))
        borderLine.backgroundColor = UIColor._lightGray3
        self.addSubview(borderLine)
    }
}
