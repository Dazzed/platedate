//
//  SearchTextField.swift
//  PlateDate
//
//  Created by WebCrafters on 04/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

final class SearchTextField: UITextField {

    // MARK: - TextField's life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        //removeIconTextField()
        setupTextField()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //removeIconTextField()
        setupTextField()
    }

    // MARK: - Main

     func setupTextField() {
        borderStyle = .roundedRect
        layer.borderColor = UIColor._lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        clipsToBounds = true

        let tagView = UIImageView(image:#imageLiteral(resourceName: "Search"))
        guard let size = tagView.image?.size  else { return }
        tagView.frame = CGRect(x: 2.0, y: 0.0, width: size.width * 1.85, height: 15 )
        tagView.contentMode = .right
        tagView.clipsToBounds = true
        tagView.contentMode = .scaleAspectFit
        leftView = tagView
        leftViewMode = .always

        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 2.0

        let borderLine = UIView(frame: CGRect(x:0, y:self.frame.height - CGFloat(width), width:self.frame.width, height:CGFloat(width)))
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }

       func removeIconTextField() {
        borderStyle = .roundedRect
        layer.borderColor = UIColor._lightGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        clipsToBounds = true

        let tagView = UIImageView(image:#imageLiteral(resourceName: "Search"))
        guard (tagView.image?.size) != nil  else { return }
        tagView.frame = CGRect(x: 50, y: 0.0, width: 15, height: 0 )
        tagView.contentMode = .right
        tagView.clipsToBounds = true
        tagView.contentMode = .scaleAspectFit
        leftView = tagView
        leftViewMode = .always

//        let tagView1 = UIImageView(image:#imageLiteral(resourceName: "Search"))
//        guard (tagView.image?.size) != nil  else { return }
//        tagView1.frame = CGRect(x: 0.0, y: 0.0, width: 15, height: 15 )
//        tagView1.contentMode = .left
//        tagView1.clipsToBounds = true
//        tagView1.contentMode = .scaleAspectFit
//        rightView = tagView1
//        rightViewMode = .always

        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 2.0

        let borderLine = UIView(frame: CGRect(x:0, y:self.frame.height - CGFloat(width), width:self.frame.width, height:CGFloat(width)))
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}
