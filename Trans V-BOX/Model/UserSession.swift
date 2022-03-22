
import UIKit

struct UserSession: MKJSONModel {
    static var shared: UserSession = getDefaultSession()
    
    static func getDefaultSession()-> UserSession {
        return UserSession(user: nil)
    }
    
    var notDisplaySuperlike:Bool = true
    var xmasActive:Bool = false
    var isOnGravitiAnimated = false
    var deviceToken: String?
    var user: UserModel?
    var setting: Setting?
    //MARK: - Save Methods
    
    static func saveUserSession(){
        guard let _ = UserSession.shared.user else{return}
        if let jsonData = UserSession.shared.toData(){
            saveUserDefault(value: jsonData, key:  AppUserDefaultKeys.kUserDetails)
            debugLog("\n----------------- Save UserSession -----------\n")
        }
    }
 
    
    //MARK: - Remove or update
    
    static func removeUserSession(){
        removeUserDefault(KEY: UserDefaultKey.isProfileCompleted)
        removeUserDefault(KEY: AppUserDefaultKeys.kAccessToken)
        removeUserDefault(KEY: UserDefaultKey.accessToken)
        UserSession.shared = UserSession.getDefaultSession()
        removeUserDefault(KEY: AppUserDefaultKeys.kUserDetails)
        removeUserDefault(KEY: UserDefaultKey.doNotShow)
    }
    
    //MARK: - Helpers
       static func getAndSetPreSavedUserSession(){
           if let userSessionData = getUserDefault(key: AppUserDefaultKeys.kUserDetails) as? Data {
               do{
                   let object = try JSONDecoder().decode(UserSession.self, from: userSessionData as Data)
                   UserSession.shared = object
               }catch{
                   print(" ------------ unable to encode user session data --------")
               }
           }
       }

}
