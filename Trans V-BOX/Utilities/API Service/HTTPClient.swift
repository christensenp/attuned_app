//
//  HTTPClientV2.swift
//  1800FlowersApp
//
//  Created by Gourav on 08/04/19.
//  Copyright © 2019 mobikasa. All rights reserved.
//

import UIKit
import Alamofire
enum HTTPClientRequest: Int {
    case post = 0, get, delete, put, patch
}
typealias CompletionBlock = (_ jsonValue : [String:Any]? ,_ statusCode:Int, _ error:Error?) -> (Void)
class HTTPClient: NSObject {
    var alamoFireManager = Alamofire.SessionManager.default
    private override init() {
        super.init()
        alamoFireManager.session.configuration.timeoutIntervalForRequest = 15
    }
    static var shared :HTTPClient? {
        if (NetworkReachabilityManager()?.isReachable)! == true {
            return HTTPClient()
        }
        else{
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach({ (task) in
                    task.cancel()
                })
            }
        }
        return nil
    }
    
    func cancellAllOperations() {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({ (task) in
                task.cancel()
            })
        }
    }
    
    func setHTTPRequest(withAPIUrl url: String, withHttpMethod method: HTTPMethod, withParameters params: [String: Any]?) -> URLRequest? {
        var request: URLRequest!
        do {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            var headers = ["Accept": "application/json",
                           "Content-Type": "application/json",
                           "device_token": UserDefaults.standard.string(forKey: UserDefaultKey.deviceToken) ?? "",
                           "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                           "device_type": "iOS",
                           "app_version":  appVersion ?? ""]
             
            if let model = UserDefaults.getAccessToken() {
                headers["access_token"] = model
            }
            request = try URLRequest.init(url: url, method: method, headers: headers)
            request.timeoutInterval = 120
            if let params = params {
                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            }
        }
        catch {
            print("****** exception in Http Request ********")
        }
        return request
    }
    
    
    func httpRequest(type: HTTPClientRequest,baseUrl:String, params:[String:Any]?, completionBlock:@escaping CompletionBlock) {
        var method: HTTPMethod!
        switch type {
        case .post:
            method = .post
        case .get:
            method = .get
        case .put:
            method = .put
        case .delete:
            method = .delete
        case .patch:
            method = .patch
        }
        if let request = setHTTPRequest(withAPIUrl: baseUrl, withHttpMethod: method, withParameters: params) {
            Alamofire.request(request).responseJSON { (responseData: DataResponse<Any>) in
                switch (responseData.result){
                case .success(_):
                    if let accessToken = responseData.response?.allHeaderFields[ UserDefaultKey.accessToken] as? String {
                        print(accessToken)
                        UserDefaults.setAccessToken(token: accessToken)
                    }
                    if let array = responseData.result.value as? [[String: Any]] {
                        completionBlock(["data": array] ,(responseData.response?.statusCode) ?? 0,responseData.result.error)
                    } else {
                        if let data = responseData.result.value as? [String : Any], let userModel = UserModel.init(object: data) {
                            if String(describing: userModel.code.value) == StringConstants.errorCode {
                                UserSession.removeUserSession()
                                let controller = AccessCodeViewController.instantiateFromStoryBoard()
                                AppDelegate.sharedDelegate().window?.rootViewController = UINavigationController(rootViewController: controller)
                                return
                            }
                        }
                        completionBlock(responseData.result.value as? [String : Any] ,(responseData.response?.statusCode) ?? 0,responseData.result.error)
                    }
                    
                    break
                case .failure(let error):
                    if (responseData.result.value == nil) {
                        if error._code == NSURLErrorNotConnectedToInternet{
                            completionBlock(nil ,600,responseData.result.error)
                            
                        } else if responseData.response?.statusCode == 500 {
                            completionBlock(nil ,500,"Unable to connect to server. Please try again after sometime." as? Error)
                            
                        }
                        else{
                            completionBlock(nil ,(responseData.response?.statusCode) ?? 0,responseData.result.error)
                        }
                    }
                    else{
                        completionBlock(responseData.result.value as? [String : Any] ,(responseData.response?.statusCode) ?? 0,responseData.result.error)
                    }
                    break
                }
            }
        }
        
    }
    
    
    //MARK:- Multipart postService Call
    func multiPartPostRequest(isAudio: Bool = false, baseUrl:String, params:[String:Any], type: HTTPClientRequest ,completionBlock:@escaping CompletionBlock )->Void{
        var method: HTTPMethod!
        switch type {
        case .post:
            method = .post
        case .get:
            method = .get
        case .put:
            method = .put
        case .delete:
            method = .delete
        case .patch:
            method = .patch
        }
        
        var tempParam = [String: Any]()
        for (key, value) in params{
            if let str = value as? String  {
                tempParam[key] = str
            } else if  let str = value as? Bool {
                tempParam[key] = str
            }  else if  let str = value as? Int {
                    tempParam[key] = str
            }
        }
        let request = setHTTPRequest(withAPIUrl: baseUrl, withHttpMethod: method, withParameters: tempParam)
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in params{
                let mimeType = isAudio ? "audio/vnd.wav" : "image/jpeg"
                if let imageData = value as? Data {
                    let fileName = isAudio ? "\(Date().timeIntervalSince1970).wav" :  "\(Date().timeIntervalSince1970).jpeg"
                    multipartFormData.append(imageData, withName: key, fileName: fileName, mimeType: mimeType)
                } else if let str = value as? String, let data = str.data(using: .utf8){
                    multipartFormData.append(data, withName: key)
                } else if let images = value as? [Data] {
                    for imageData in images {
                        let fileName = isAudio ? "\(Date().timeIntervalSince1970).wav" :  "\(Date().timeIntervalSince1970).jpeg"
                        multipartFormData.append(imageData, withName: key, fileName: fileName, mimeType: mimeType)
                    }
                }
            }
        }, with: request! as URLRequestConvertible) { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { (responseData: DataResponse<Any>) in
                    switch (responseData.result){
                    case .success(_):
                        if let array = responseData.result.value as? [[String: Any]] {
                            completionBlock(["data": array] ,(responseData.response?.statusCode) ?? 0, responseData.result.error)
                        } else {
                            completionBlock(responseData.result.value as? [String : Any] ,(responseData.response?.statusCode) ?? 0, responseData.result.error)
                        }
                        break
                    case .failure(let error):
                        if (responseData.result.value == nil) {
                            if error._code == NSURLErrorNotConnectedToInternet{
                                completionBlock(nil ,600,responseData.result.error)
                                
                            } else if responseData.response?.statusCode == 500 {
                                completionBlock(nil ,500,"Unable to connect to server. Please try again after sometime." as? Error)
                            } else{
                                completionBlock(nil ,(responseData.response?.statusCode) ?? 0,responseData.result.error)
                            }
                        } else{
                            completionBlock(responseData.result.value as? [String : Any] ,(responseData.response?.statusCode) ?? 0,responseData.result.error)
                        }
                        break
                    }
                }
                break
                
            case .failure(let encodingError):
                
                completionBlock(nil ,0,encodingError)
            }
        }
    }
    
    
    func downloadFile(audioURL: URL, completionBlock:@escaping DataCompletionBlock) {
        let audioFileName = String(audioURL.lastPathComponent) as NSString
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(audioFileName as String)
        if FileManager.default.fileExists(atPath: documentsURL.path) {
             try? (documentsURL as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
            completionBlock(documentsURL, 200, nil)
        } else {
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (documentsURL, [.removePreviousFile])
            }
            Alamofire.download(audioURL, to: destination).response { response in
                completionBlock(response.destinationURL, 200, nil)
            }
        }
    }
    
}
