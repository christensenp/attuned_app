//
//  AppDelegate.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/25/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AudioKit
import Firebase

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    var shadowImage: UIImage?
    var recCount: Int = 1
    var backgroundSessionCompletionHandler: (() -> Void)?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        let contoller = ProfileStep4ViewController.instantiateFromStoryBoard()
        //        window?.rootViewController = contoller
//        sleep(2)

        PushManager.shared.registerNotificaton(appDelegate: self)
        UserSession.getAndSetPreSavedUserSession()
//        AppRouter.shared.setInitials()
        AppRouter.shared.showSplashScreen()
        FirebaseApp.configure()
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 60
        self.updateDeviceToken()
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.registerBackgroundTask()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        PushManager.shared.clearBadge()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserSession.saveUserSession()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        BackgroundSession.shared.savedCompletionHandler = completionHandler
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
    
    static func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func registerBackgroundTask() {
      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
        self?.endBackgroundTask()
      }
    }

    func endBackgroundTask() {
      print("Background task ended.")
      UIApplication.shared.endBackgroundTask(backgroundTask)
      backgroundTask = .invalid
    }

    func updateDeviceToken() {
        guard let _ = UserSession.shared.user else { return }
        APIManager.shared.updateDeviceToken { (response, status, error) -> (Void) in
            //print(response)
        }
        APIManager.shared.getSettings { (response, status, error) -> (Void) in
            if let response = response as? SettingsModel {
                UserSession.shared.setting = response.data
            }
        }
    }
}

