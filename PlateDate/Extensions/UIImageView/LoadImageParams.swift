//
//  LoadImageParams.swift
//  PlateDate
//
//  Created by WebCrafters on 01/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//
//Shivasparrow1
import UIKit
//95856 59622
// Mark: - Params with ImageView
struct LoadImageParams {
    
    let backgroundColor: UIColor
    let placeholder: UIImage?
    let placeholderContentMode: UIViewContentMode
    let contentMode: UIViewContentMode
    let showActivityIndicator: Bool
    let cornerRadius: CGFloat
    let forceRefresh: Bool
    let resizeBeforeCaching: Bool
    
    init(backgroundColor: UIColor = UIColor.clear, placeholder: UIImage? = nil,  placeholderContentMode: UIViewContentMode = .center, contentMode: UIViewContentMode = .scaleAspectFill, showActivityIndicator: Bool = true, cornerRadius: CGFloat = 0.0, forceRefresh: Bool = false, resizeBeforeCaching: Bool = true ) {
        self.backgroundColor = backgroundColor
        self.placeholder = placeholder
        self.placeholderContentMode = placeholderContentMode
        self.contentMode = contentMode
        self.showActivityIndicator = showActivityIndicator
        self.cornerRadius = cornerRadius
        self.forceRefresh = forceRefresh
        self.resizeBeforeCaching = resizeBeforeCaching
    }
}
