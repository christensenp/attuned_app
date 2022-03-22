//
//  AppInitialisers.swift
//  Sagexool
//
//  Created by Sagexool on 05/02/19.
//  Copyright © 2019 Sagexool. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class AppRouter: NSObject{
    
    //MARK: - Initializers
    static let shared = AppRouter()
    private override init() {
    }
    
    func setInitials() {
        //------ no user found -------
        guard let _ = UserSession.shared.user else{
            moveToLandingScreen()
            return;
        }
        if UserDefaults.standard.bool(forKey: UserDefaultKey.isProfileCompleted) {
            moveToDashBoardScreen()
        } else {
            moveToHomeScreen()
        }
    }
    
    //MARK: - Navigation Methods
    
    func showSplashScreen(){
//        let introductionViewController = SplashViewController.instantiateFromStoryBoard()
//        setWindowWithWithoutAnimation(vc: introductionViewController)
    }
    
    func moveToLandingScreen(){
        let introductionViewController = AccessCodeViewController.instantiateFromStoryBoard()
        setWindowWith(vc: introductionViewController)
    }
    
    func moveToHomeScreen(){
        let homeTabBarViewController = GetStartedViewController.instantiateFromStoryBoard()
        setWindowWith(vc: homeTabBarViewController)
    }
    
    func moveToDashBoardScreen(){
//        let homeTabBarViewController = EmptyViewController.instantiateFromStoryBoard()
//        setWindowWith(vc: homeTabBarViewController)
        
        
        let storyboard = UIStoryboard.init(name: Storyboard.profile, bundle: nil)
        let tabController = storyboard.instantiateViewController(withIdentifier: ViewIdentifiers.TabBarViewController)
        AppDelegate.sharedDelegate().window?.rootViewController = tabController
    }
    
    //MARK: - Actions
    func openUrlFromApp(url: URL, completion: CompletionWithStatus?){
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, completionHandler: { (success) in
                if let completion = completion{
                    completion(success)
                }
            })
        }
    }
    
    
    //MARK: - Helpers
    func setWindowWith(vc:UIViewController) {
        //navView.interactivePopGestureRecognizer?.isEnabled = false
        
        AppDelegate.sharedDelegate().window?.rootViewController = UINavigationController(rootViewController: vc)
        AppDelegate.sharedDelegate().window?.makeKeyAndVisible()
        
        
        UIView.transition(with:  AppDelegate.sharedDelegate().window ?? UIWindow(), duration: 0.3, options: .transitionCrossDissolve, animations: {
            AppDelegate.sharedDelegate().window?.rootViewController = UINavigationController(rootViewController: vc)
            AppDelegate.sharedDelegate().window?.makeKeyAndVisible()
        }, completion: { completed in
            // maybe do something here
        })
        
    }
    func setWindowWithWithoutAnimation(vc:UIViewController) {
        //navView.interactivePopGestureRecognizer?.isEnabled = false
        
        AppDelegate.sharedDelegate().window?.rootViewController = UINavigationController(rootViewController: vc)
        AppDelegate.sharedDelegate().window?.makeKeyAndVisible()
        
//        AppDelegate.sharedDelegate().window?.rootViewController = UINavigationController(rootViewController: vc)
//        AppDelegate.sharedDelegate().window?.makeKeyAndVisible()
        
        
//        UIView.transition(with:  AppDelegate.sharedDelegate().window ?? UIWindow(), duration: 0.3, options: .transitionCrossDissolve, animations: {
//            AppDelegate.sharedDelegate().window?.rootViewController = UINavigationController(rootViewController: vc)
//            AppDelegate.sharedDelegate().window?.makeKeyAndVisible()
//        }, completion: { completed in
//            // maybe do something here
//        })
        
    }
}
