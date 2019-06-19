//
//  AppDelegate.swift
//  PlateDate
//
//  Created by WebCrafters on 01/12/18.
//  Copyright © 2018 WebCrafters. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import ParseFacebookUtilsV4
import Parse
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { 

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Mark: - Facebooksa
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
//        let parseConfig = ParseClientConfiguration {
//            $0.applicationId = "4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN"
//            $0.clientKey = "GoRbjXQXUnR4AduQorgjCjOP5ONQfUQEaXJ7oY7L"
//            $0.server = "https://pg-app-jangz55flypj0s6vj9ygbi05egv1j0.scalabl.cloud/1/"
//        }
        //Parse.initialize(with: parseConfig)

        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN"
            $0.clientKey = "GoRbjXQXUnR4AduQorgjCjOP5ONQfUQEaXJ7oY7L"
            $0.server = "https://pg-app-jangz55flypj0s6vj9ygbi05egv1j0.scalabl.cloud/1/"
        }
        Parse.initialize(with: parseConfig)

         //PFAnalytics.trackAppOpened(launchOptions: launchOptions)
       //Parse.setApplicationId("4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN", clientKey:"GoRbjXQXUnR4AduQorgjCjOP5ONQfUQEaXJ7oY7L")
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)

//        //Parse.setApplicationId("4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN", clientKey: "GoRbjXQXUnR4AduQorgjCjOP5ONQfUQEaXJ7oY7L")
//      //  PFAnalytics.trackAppOpened(launchOptions: launchOptions)
//        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//
//         PFUser.enableRevocableSessionInBackground()

        return true
    }

func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }


//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        // Mark: - Facebooksa
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
//
//      //  Parse.setApplicationId("4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN", clientKey: "4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN")
//
//         let parseConfig = ParseClientConfiguration {
//            $0.applicationId = "4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN"
//            $0.clientKey = "4oZLIvHYbqOJxXDPzqBZ3mlJ6EPYWIOQoUaL57fN"
//            $0.server = "https://pg-app-jangz55flypj0s6vj9ygbi05egv1j0.scalabl.cloud/1/"
//        }
//
//        Parse.initialize(with: parseConfig)
//
//        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
//        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//
//       // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//
//       // Parse.initialize(with: parseConfig)
//      //  PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
//        return true
//    }
//
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
            
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
         FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PlateDate")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//extension AppDelegate {
//
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
//            let url = userActivity.webpageURL!
//            let _ = url.query ?? ""
//                let navigationController = self.window?.rootViewController as! UINavigationController
//                let secondViewController = UIStoryboard(name: "ProfileInfo", bundle: nil).instantiateViewController(withIdentifier: "Slide")
//                navigationController.pushViewController(secondViewController, animated: true)
//
//            return true
//        }
//        return false
//    }
//
//    func presentCustomViewController(url:URL){
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
//        guard components.host != nil else {
//            return
//        }
//        let navigationController = self.window?.rootViewController as! UINavigationController
//        let secondViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EmailLogin")
//        navigationController.pushViewController(secondViewController, animated: true)
//    }
//}
