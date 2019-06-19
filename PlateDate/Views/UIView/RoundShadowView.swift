//
//  RoundShadowView.swift
//  PlateDate
//
//  Created by WebCrafters on 13/02/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
        //fatalError("init(coder:) has not been implemented")
    }

    func layoutView() {

      // set the shadow of the view's layer
      layer.backgroundColor = UIColor.clear.cgColor
      layer.shadowColor = UIColor._lightGrayShadow.cgColor
      layer.shadowOffset = CGSize(width: 0, height:3.0)
      layer.shadowOpacity = 1
      layer.shadowRadius = 1
      clipsToBounds = false

      let containerView = UIView()
      let cornerRadius: CGFloat = 10.0

      // set the cornerRadius of the containerView's layer
      containerView.layer.cornerRadius = cornerRadius
      containerView.layer.masksToBounds = true

      addSubview(containerView)

      // add constraints
      containerView.translatesAutoresizingMaskIntoConstraints = false

      // pin the containerView to the edges to the view
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
      containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
