//  BaseViewController.swift
//  Created by Trans V-BOX on 23/01/2020.
//  Copyright © 2020 Trans V-BOX. All rights reserved.


import UIKit
import SVProgressHUD
import Toast_Swift
import SCLAlertView
import EventKit
import EventKitUI

//--- To enable BaseviewController to be instantiable From storyboard id -----
protocol InstantiableFromStoryboard {
    static var storyBoardId: String{get}
    static var storyBoardName: String{get}
    static func instantiateFromStoryBoard()->Self//-----optional func
}

extension InstantiableFromStoryboard {
    static func instantiateFromStoryBoard()->Self{
        let storyBoard = UIStoryboard.init(name: storyBoardName, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: storyBoardId)
        return vc as! Self
    }
}

typealias BaseViewController = BaseViewControllerClass & InstantiableFromStoryboard

class BaseViewControllerClass: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: Font.YuGothicBold, size: 18) ?? UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.colorWithRGB(r: 111, g: 118, b: 139)]
        if AppDelegate.sharedDelegate().shadowImage == nil {
            AppDelegate.sharedDelegate().shadowImage = self.navigationController?.navigationBar.shadowImage
        }
        self.setUPNavigationBarColor()
        self.setProgressStyle()
        
        // Do any additional setup after loading the view.
    }
    func setUPNavigationBarColor(isClearColor: Bool = true) {
        self.navigationController?.navigationBar.isTranslucent = isClearColor
        if isClearColor {
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.view.backgroundColor = UIColor.clear
        } else {
            let image = UIImage.init(color: .white, size: CGSize(width: SCREEN_WIDTH, height: self.navigationController?.navigationBar.frame.size.height ?? 0))
            self.navigationController?.navigationBar.shadowImage = AppDelegate.sharedDelegate().shadowImage
            self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        }
    }
    
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setRightBarButtonItem(imageName: String, isText: Bool = false) {
        var rightBarButtonItem: UIBarButtonItem!
        if isText {
            rightBarButtonItem = UIBarButtonItem(title: imageName, style: .plain, target: self, action: #selector(rightButtonAction(_ :)))
        } else {
            rightBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: self, action: #selector(rightButtonAction(_ :)))
        }
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setLeftBarButtonItem(imageName: String, isText: Bool = false) {
        var leftBarButtonItem: UIBarButtonItem!
        if isText {
            leftBarButtonItem = UIBarButtonItem(title: imageName, style: .plain, target: self, action: #selector(leftButtonAction(_ :)))
        } else {
            leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: self, action: #selector(leftButtonAction(_ :)))
        }
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setBackgroundColor(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setProgressStyle() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
    }
    
    func showLoading() {
        SVProgressHUD.show()
    }
    
    func stopLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showToast(message: String) {
        AppDelegate.sharedDelegate().window?.makeToast(message)
    }
    
    func push(_ controller: BaseViewController, _ animated: Bool = true) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
    @objc func rightButtonAction(_ sender: Any) {
        
    }
    
    @objc func leftButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String, completion: EmptyAction?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.OK, style: .default, handler: { (_) in
            if let completionHandler = completion {
                completionHandler()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentAddCallNotificationContoller(name: String) {
        let controller = CallNotificationViewController.instantiateFromStoryBoard()
        controller.recordingName = name
        let root = UINavigationController(rootViewController: controller)
        root.modalPresentationStyle = .fullScreen
        self.present(root, animated: true, completion: nil)
    }
    
    func showAlertYesOrNo(title: String?, message: String, completion: EmptyAction?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.no, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.Yes, style: .default, handler: { (_) in
            if let completionHandler = completion {
                completionHandler()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showWarningAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.OK, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(isUpdate: Bool, text: String, handler: @escaping SLAlertCompletion) {
        let controller = SaveRecordingViewController.instantiateFromStoryBoard()
        controller.recodingName = text
        controller.isUpdate = isUpdate
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.handler = handler
        if let tabBarController = self.tabBarController {
            tabBarController.present(controller, animated: true, completion: nil)
        } else {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
