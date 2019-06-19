//
//  SwipeViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 13/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mark: - SwipeGestureRecognizer
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

         let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
         swipeLeft.direction = UISwipeGestureRecognizerDirection.left
         self.view.addGestureRecognizer(swipeLeft)
    }

    // Mark: - Swipe Redirect Page
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
               navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.dashBaord, storyBoardId: TabBar.tabBarStoryBoardId)

             case UISwipeGestureRecognizerDirection.left:
                 navigationPushRedirect(storyBoardName: ViewController.StroyBoardName.dashBaord, storyBoardId: TabBar.tabBarStoryBoardId)

            default:
                break
            }
        }
    }
}
