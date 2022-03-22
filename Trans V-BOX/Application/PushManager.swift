//
//  RegisterNotificationHandler.swift
//  Trans V-BOX
//
//  Created by Gourav on 01/04/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class PushManager: NSObject {
    
    static let shared = PushManager()
    
    func registerNotificaton(appDelegate: AppDelegate) {
        let center = UNUserNotificationCenter.current()
        center.delegate = appDelegate
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func clearBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        if let type = info[APIKeys.type] as? String {
            switch type {
            case PushType.saveRecording.rawValue:
                self.openTabScreen(index: 2)
            case PushType.reminder.rawValue:
                self.openTabScreen(index: 1)
            case PushType.adminNotifications.rawValue:
                self.openNotificationScreen()
            default:
                break;
            }
            print(info)
        }

    }

    func openTabScreen(index: Int){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            if let rootView = AppDelegate.sharedDelegate().window?.rootViewController as? UITabBarController,
                let tabVCs = rootView.viewControllers,
                tabVCs.count == 4 {
                rootView.selectedIndex = index
            }
        }
    }

    func openNotificationScreen(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            if let rootView = AppDelegate.sharedDelegate().window?.rootViewController as? UITabBarController,
                let tabVCs = rootView.viewControllers,
                tabVCs.count == 4 {
                if let navController = rootView.selectedViewController as? UINavigationController {
                    let notificationsViewController = NotificationsViewController.instantiateFromStoryBoard()
                    navController.pushViewController(notificationsViewController, animated: true)
                }
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print(token)
        UserDefaults.standard.set(token, forKey: UserDefaultKey.deviceToken)
        self.updateDeviceToken()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
