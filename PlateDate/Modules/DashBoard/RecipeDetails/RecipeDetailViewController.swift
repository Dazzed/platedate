//
//  RecipeDetailViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 26/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    // Mark: - @IBOutlets
    @IBOutlet var segmentTitle: ScrollableSegmentedControl!
    @IBOutlet var ingredientsView: UIView!
    @IBOutlet var preparationView: UIView!
    @IBOutlet var commentsView: UIView!
    @IBOutlet var shadowImageView: UIImageView!
    @IBOutlet var shadowImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet var height1: NSLayoutConstraint!
    @IBOutlet var height2: NSLayoutConstraint!
    @IBOutlet var height3: NSLayoutConstraint!


    // Mark: - @IBOutlets for Tab layout Animation
    @IBOutlet var ingredientViewLeadingConstraint: NSLayoutConstraint!
     @IBOutlet var ingredientViewTrailingConstraint: NSLayoutConstraint!

      @IBOutlet var preparationViewLeadingConstraint: NSLayoutConstraint!
     @IBOutlet var preparationViewTrailingConstraint: NSLayoutConstraint!

      @IBOutlet var commentsViewLeadingConstraint: NSLayoutConstraint!
     @IBOutlet var commentsViewTrailingConstraint: NSLayoutConstraint!

     let screenSize = UIScreen.main.bounds

    @IBOutlet var NutritionFactButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegment()

        NutritionFactButton.layer.masksToBounds = false
        NutritionFactButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        NutritionFactButton.layer.shadowRadius = 5
        NutritionFactButton.layer.shadowOpacity = 0.7
        NutritionFactButton.layer.shadowColor = UIColor.lightGray.cgColor

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))

        // Move to the Top Right Corner
        //path.addLine(to: CGPoint(x: NutritionFactButton.frame.width, y: 0.0))

        // Move to the Bottom Right Corner
        path.addLine(to: CGPoint(x: NutritionFactButton.frame.width, y: NutritionFactButton.frame.height))

        // This is the extra point in the middle :) Its the secret sauce.
        path.addLine(to: CGPoint(x: NutritionFactButton.frame.width / 2.0, y: NutritionFactButton.frame.height / 2.0))

        // Move to the Bottom Left Corner
        path.addLine(to: CGPoint(x: 0.0, y:NutritionFactButton.frame.height))

        // Move to the Close the Path
        path.close()

        NutritionFactButton.layer.shadowPath = path.cgPath


        // Do any additional setup after loading the view.
    }
    

    func setUpSegment() {
        segmentTitle.segmentStyle = .textOnly
        segmentTitle.insertSegment(withTitle: "Ingredients", image: nil, at: 0)
        segmentTitle.insertSegment(withTitle: "Preparation", image: nil, at: 1)
        segmentTitle.insertSegment(withTitle: "Comments", image: nil, at: 2)
        segmentTitle.underlineSelected = true
        segmentTitle.selectedSegmentIndex = 0
        segmentTitle.fixedSegmentWidth = true
        segmentTitle.tintColor = UIColor._lightningYellow

        preparationViewLeadingConstraint.constant = screenSize.width
        preparationViewTrailingConstraint.constant = -screenSize.width

        commentsViewLeadingConstraint.constant = 2 * screenSize.width
        commentsViewTrailingConstraint.constant = -2 * screenSize.width

        // Mark: - Tablayout Animation


        segmentTitle.addTarget(self, action: #selector(RecipeDetailViewController.segmentSelected(sender:)), for: .valueChanged)
    }

    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        if sender.selectedSegmentIndex == 0 {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.ingredientViewAnimation()

            })
        } else if sender.selectedSegmentIndex == 1 {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.preparationViewAnimation()
             })
        } else {
             UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.commentsViewAnimation()
                self.view.layoutIfNeeded()
             })
        }
    }

    // Mark: - TabLayout Animation for Ingredient View
        func ingredientViewAnimation() {
            ingredientViewLeadingConstraint.constant = 0
            ingredientViewTrailingConstraint.constant = 0
            preparationViewLeadingConstraint.constant = screenSize.width
            preparationViewTrailingConstraint.constant = -screenSize.width
            commentsViewLeadingConstraint.constant = 2 * screenSize.width
            commentsViewTrailingConstraint.constant = -2 * screenSize.width
            shadowImageViewHeightConstraint.constant = 400
            self.view.layoutIfNeeded()
        }

        // Mark: - TabLayout Animation for Ingredient View
        func preparationViewAnimation() {
            ingredientViewLeadingConstraint.constant = -screenSize.width
            ingredientViewTrailingConstraint.constant = screenSize.width
            preparationViewLeadingConstraint.constant = 0
            preparationViewTrailingConstraint.constant = 0
            commentsViewLeadingConstraint.constant =  screenSize.width
            commentsViewTrailingConstraint.constant = -screenSize.width
            shadowImageViewHeightConstraint.constant = 1000
            self.view.layoutIfNeeded()
        }

        // Mark: - TabLayout Animation for Ingredient View
        func commentsViewAnimation() {
            ingredientViewLeadingConstraint.constant = 2 * -screenSize.width
            ingredientViewTrailingConstraint.constant = 2 * screenSize.width
            preparationViewLeadingConstraint.constant = -screenSize.width
            preparationViewTrailingConstraint.constant = screenSize.width
            commentsViewLeadingConstraint.constant =  0
            commentsViewTrailingConstraint.constant = 0
            shadowImageViewHeightConstraint.constant = 2000
            self.view.layoutIfNeeded()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

