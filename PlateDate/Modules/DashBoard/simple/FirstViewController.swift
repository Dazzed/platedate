//
//  FirstViewController.swift
//  PlateDate
//
//  Created by WebCrafters on 25/03/19.
//  Copyright © 2019 WebCrafters. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    let simpleOver = SimpleOver()

    override func viewDidLoad() {
        super.viewDidLoad()
   // navigationController?.delegate = self
    //self.navigationController?.navigationBar.isTranslucent = false

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.view.backgroundColor = UIColor.white
    }

    private func navigationController(_ navigationController: UINavigationController,animationControllerFor operation: UINavigationControllerOperation, from fromVC: FirstViewController, to toVC: SecondViewController) -> UIViewControllerAnimatedTransitioning? {
        simpleOver.popStyle = (operation == .pop)
        return simpleOver
    }


    @IBAction func buttonAction(_ sender: Any) {

        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "second") as! SecondViewController
         let nav = self.navigationController //grab an instance of the current navigationController
        DispatchQueue.main.async { //make sure all UI updates are on the main thread.
            nav?.view.layer.add(CATransition().segueFromBottom(), forKey: nil)
            nav?.pushViewController(settingsVC, animated: false)
        }

//
//        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "second") as! SecondViewController
//let transition = CATransition()
//transition.duration = 0.5
//transition.type = kCATransitionPush
//transition.subtype = kCATransitionFromTop
//view.window!.layer.add(transition, forKey: kCATransition)
//self.present(settingsVC, animated: true, completion: nil)
//self.navigationController?.pushViewController(settingsVC, animated: false)

  //  let n = UIStoryboard(name: "BookMark", bundle: nil).instantiateViewController(withIdentifier: "second")as! SecondViewController
   // navigationController?.pop
   //    navigationController()


   // let settingsVC = SecondViewController()

//        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "second") as! SecondViewController
//
//    let transition = CATransition()
//    transition.duration = 0.5
//    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//    transition.type = kCATransitionPush
//    transition.subtype = kCATransitionFromTop
//    navigationController?.view.layer.add(transition, forKey: kCATransition)
//    navigationController?.pushViewController(settingsVC, animated: false)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CATransition {

//New viewController will appear from bottom of screen.
func segueFromBottom() -> CATransition {
    self.duration = 0.375 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    self.type = kCATransitionMoveIn
    self.subtype = kCATransitionFromTop
    return self
}
//New viewController will appear from top of screen.
func segueFromTop() -> CATransition {
    self.duration = 0.375 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    self.type = kCATransitionMoveIn
    self.subtype = kCATransitionFromBottom
    return self
}
 //New viewController will appear from left side of screen.
func segueFromLeft() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    self.type = kCATransitionMoveIn
    self.subtype = kCATransitionFromLeft
    return self
}
//New viewController will pop from right side of screen.
func popFromRight() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    self.type = kCATransitionReveal
    self.subtype = kCATransitionFromRight
    return self
}
//New viewController will appear from left side of screen.
func popFromLeft() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    self.type = kCATransitionReveal
    self.subtype = kCATransitionFromLeft
    return self
   }
}


class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {

        var popStyle: Bool = false

        func transitionDuration(
            using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.20
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

            if popStyle {

                animatePop(using: transitionContext)
                return
            }

            let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

            let f = transitionContext.finalFrame(for: tz)

            let fOff = f.offsetBy(dx: f.width, dy: 55)
            tz.view.frame = fOff

            transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)

            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    tz.view.frame = f
            }, completion: {_ in
                    transitionContext.completeTransition(true)
            })
        }

        func animatePop(using transitionContext: UIViewControllerContextTransitioning) {

            let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

            let f = transitionContext.initialFrame(for: fz)
            let fOffPop = f.offsetBy(dx: f.width, dy: 55)

            transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)

            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    fz.view.frame = fOffPop
            }, completion: {_ in
                    transitionContext.completeTransition(true)
            })
        }
    }


    class FrontScreen: UIViewController,
        UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    let simpleOver = SimpleOver()


    override func viewDidLoad() {

        super.viewDidLoad()
        navigationController?.delegate = self
    }

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        simpleOver.popStyle = (operation == .pop)
        return simpleOver
    }
}
