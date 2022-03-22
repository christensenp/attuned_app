//
//  AppConstants.swift
//  Trans V-BOX
//  Created by Trans V-BOX on 23/01/2020.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD

//MARK: - Constants

let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height
let SCREEN_SIZE: CGSize = UIScreen.main.bounds.size
let IMAGE_COMPRESSION_CONSTANT:CGFloat = 0.8
let IMAGE_COMPRESSION_CONSTANT_FOR_CHAT:CGFloat = 0.8
let BUTTONTHEMECOLOR = UIColor.colorWithRGB(r: 111, g: 118, b: 139)
let showSWR = false
let disableColor = UIColor.init("#F6F7FC")

struct AppUserDefaultKeys{
    static let kAccessToken:String = "AccessToken"
    static let kUserDetails:String = "kUserDetails"
    static let kCommonData: String = "kCommonData"
}
struct AppConstants{
    static var ISLOGIN:String = "isLogin"
    static var DEVICETOKEN:String = "DeviceToken"
    static func getDeviceToken()->String{
        return "\(getUserDefault(key: DEVICETOKEN) ?? "1234")"
    }
}

func getKeyBoardHeight(_ notification :Notification)-> CGFloat{
    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    return keyboardRectangle.height
}


//MARK: - Utility functions

let DeviceIdString:String = {
    return UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
}()
let DeviceDetailsString: String = {
    let systemVersion = UIDevice.current.systemVersion
    let deviceName = UIDevice.modelName
    let details = "\(systemVersion),\(deviceName)"
    return details
}()
let AppVersion: String = {
    if let version :String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
        return version
    }
    return ""
}()


func debugLog(_ obj:Any){ //--------- TO PRINT ONLY ON DEBUG
    #if DEBUG
    print(obj)
    #endif
}

func filePath(key:String) -> String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    let finalUrl = url!.appendingPathComponent(key).path
    return finalUrl
}

func getDictionaryFromStr(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}


//MARK: - UserDefaults
func saveUserDefault(value : Any, key : String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getUserDefault(key: String) -> Any? {
    return UserDefaults.standard.object(forKey: key)
}

func removeUserDefault(KEY: String) {
    UserDefaults.standard.removeObject(forKey: KEY)
    UserDefaults.standard.synchronize()
}

func setDeviceToken(value:String){
    saveUserDefault(value: value, key: AppConstants.DEVICETOKEN)
}

struct Font {
    static let YuGothicMedium = "YuGothic-Medium"
    static let YuGothicRegular = "YuGothic-Regular"
    static let YuGothicLight = "YuGothic-Light"
    static let YuGothicBold = "YuGothic-Bold"
}


struct Colors {
    static let colors = ["#FEE9E3", "#E6E1FF", "#DAF9F2", "#F9F4DE", "#D5EAF8"]
}
