//
//  SettingsViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 19/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import EventKit

class SettingsViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.SettingsViewController
    static var storyBoardName: String = Storyboard.settings
    var settingsModel = [Settings]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(CellIdentifiers.SettingsTableViewCell)
        tableView.registerCell(CellIdentifiers.LogoutTableViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataToTableView()
    }
    
    func setDataToTableView(){
        settingsModel = []
        settingsModel.append(Settings(title: StringConstants.Notifications, isSwitchHidden: true, isArrowImageHidden: false, iconImage:ImageConstants.disclaimer, toggleValue: false))
        settingsModel.append(Settings(title: StringConstants.pushNotifications, isSwitchHidden: false, isArrowImageHidden: true, iconImage:ImageConstants.pushNotificationImage, toggleValue: UserSession.shared.setting?.isPushNotificationEnabled ?? true))
        settingsModel.append(Settings(title: StringConstants.Profile_Settings, isSwitchHidden: true, isArrowImageHidden: false, iconImage:ImageConstants.disclaimer, toggleValue: false))
        settingsModel.append(Settings(title: StringConstants.reminder, isSwitchHidden: true, isArrowImageHidden: false, iconImage: ImageConstants.reminder, toggleValue: UserDefaults.standard.bool(forKey: UserDefaultKey.isCallNotificationEnabled)))
        settingsModel.append(Settings(title: StringConstants.disclaimer, isSwitchHidden: true, isArrowImageHidden: false, iconImage:ImageConstants.disclaimer, toggleValue: false))
        settingsModel.append(Settings(title: StringConstants.passwordChange, isSwitchHidden: true, isArrowImageHidden: false, iconImage: ImageConstants.passwordChange, toggleValue: false))
        settingsModel.append(Settings(title: StringConstants.logout, isSwitchHidden: true, isArrowImageHidden: true, iconImage: ImageConstants.passwordChange, toggleValue: false))
        tableView.reloadData()
    }
    
}

// MARK: - TableView DataSource and Delegate Methods
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch settingsModel[indexPath.row].title {
        case StringConstants.logout:
            let logoutCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.LogoutTableViewCell) as! LogoutTableViewCell
            logoutCell.selectionStyle = .none
            return logoutCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SettingsTableViewCell) as! SettingsTableViewCell
            cell.selectionStyle = .none
            cell.setCellData(data: settingsModel[indexPath.row], handler: { [weak self] status in
                guard let self = self else {return}
                if self.settingsModel[indexPath.row].title == StringConstants.reminder {
                    UserDefaults.standard.set(status, forKey: UserDefaultKey.isCallNotificationEnabled)
                    UserSession.saveUserSession()
                    if !status {
                        self.removeEvents()
                    }
                } else {
                    self.settingsModel[indexPath.row].toggleValue = status
                    self.updateSettings()
                }
            })
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingsModel[indexPath.row].title {
        case StringConstants.Notifications:
            let controller = NotificationsViewController.instantiateFromStoryBoard()
            push(controller)
        case StringConstants.reminder:
            let controller = ReminderListViewController.instantiateFromStoryBoard()
            push(controller)
        case StringConstants.disclaimer:
            let controller = DisclaimerViewController.instantiateFromStoryBoard()
            controller.isFromSetting = true
            let root = UINavigationController(rootViewController: controller)
            root.modalPresentationStyle = .fullScreen
            self.present(root, animated: true, completion: nil)
        case StringConstants.Profile_Settings:
            let segmentViewController = ProfileSegmentViewController.instantiateFromStoryBoard()
            self.push(segmentViewController)
        case StringConstants.passwordChange:
            let controller = ChangePasswordViewController.instantiateFromStoryBoard()
            let root = UINavigationController(rootViewController: controller)
            root.modalPresentationStyle = .fullScreen
            self.present(root, animated: true, completion: nil)
        case StringConstants.logout:
            self.showAlertYesOrNo(title: StringConstants.Logout, message: StringConstants.logoutMessage, completion: {[weak self] in
                guard let self = self else {return}
                self.logout()
            })
        default:
            return
        }
    }
}

extension SettingsViewController {
    
    func removeEvents() {
        CalendarManager.shared.removeEvents()
    }
    
    func logout() {
        self.showLoading()
        APIManager.shared.logout { [weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    UserSession.removeUserSession()
                    AppRouter.shared.setInitials()
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
    }
    
    
    func updateSettings() {
        if let isPushNotificationEnabled = self.settingsModel.filter({$0.title == StringConstants.pushNotifications}).first?.toggleValue, let isCallNotificationEnabled = self.settingsModel.filter({$0.title == StringConstants.pushNotifications}).first?.toggleValue  {
            let params = [APIKeys.isPushNotificationEnabled: isPushNotificationEnabled, APIKeys.isCallNotificationEnabled: isCallNotificationEnabled]
            
            UserSession.shared.setting?.isPushNotificationEnabled = isPushNotificationEnabled
            self.showLoading()
            APIManager.shared.updateSettings(param: params) { [weak self] (response, status, error) -> (Void) in
                guard let self = self else {return}
                self.stopLoading()
                if let response = response as? UserModel {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
                }
            }
        }
    }
}
