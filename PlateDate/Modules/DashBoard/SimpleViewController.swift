//
//  SimpleViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 05/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class SimpleViewController: UIViewController {

    @IBOutlet var shadowview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        shadowview.addshadow(top: false, left: true, bottom: true, right: true, shadowRadius: 2.0   )


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIView {

    func roundedUIView(radius:CGFloat,color:CGColor,borderWidth:CGFloat){
        layer.cornerRadius = radius
        layer.borderColor = color
        layer.borderWidth = borderWidth
    }

    func dropShadow(shadowOpacity:Float,width:CGFloat,height:CGFloat,radius:CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width:width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIView {
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0) {

        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}



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


class RoundShadowView1: UIView {

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



