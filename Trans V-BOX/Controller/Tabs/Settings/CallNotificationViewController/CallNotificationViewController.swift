//
//  CallNotificationViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 21/04/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import EventKit

class CallNotificationViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.CallNotificationViewController
    static var storyBoardName: String = Storyboard.settings
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var repeatLabel: UILabel!
    var recordingName: String!
    let formatter = DateFormatter()
    var startDate = Date()
    var eventIdentifier: String!
    var reminder: Reminder?
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMM dd, yyyy  hh:mm a"
        dateLabel.text = formatter.string(from: startDate)
        self.title = StringConstants.setCallNotification
        self.setRightBarButtonItem(imageName: StringConstants.done, isText: true)
        self.setLeftBarButtonItem(imageName: StringConstants.cancel, isText: true)
        self.setUPNavigationBarColor(isClearColor: false)
        if let reminder = self.reminder, let value = reminder.reminderTime?.value, let reminderTime = Double("\(value)"), let repeatType = reminder.repeatType?.capitalized {
            self.startDate = Date(timeIntervalSince1970: reminderTime)
            datePicker.date =  self.startDate
            dateLabel.text = formatter.string(from: startDate)
            repeatLabel.text = (repeatType == StringConstants.never) ? repeatType : "Every \(repeatType)"
            allDaySwitch.isOn = reminder.isAllDay ?? false
        }
    }

    override func rightButtonAction(_ sender: Any) {

        let repeatType = repeatLabel.text!.replacingOccurrences(of: "Every ", with: "").trim().lowercased()
        var param: [String: Any] = [APIKeys.repeatType: repeatType, APIKeys.reminderTime: "\(startDate.currentTimeMillis())", APIKeys.isAllDay: allDaySwitch.isOn]
        var isUpdate = false
        if let reminder = reminder {
            param[APIKeys.reminderId] = reminder.id ?? ""
            isUpdate = true
        }

        self.showLoading()
        APIManager.shared.setReminder(isUpdate: isUpdate , param: param) { [weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                     let endDate = Calendar.current.date(byAdding: .minute, value: 20, to: self.startDate)!
                     if !isUpdate {
                        CalendarManager.shared.addEventToCalendar(title: "Tran V Recording", startDate: self.startDate, endDate: endDate, isAllDay: self.allDaySwitch.isOn, rule: self.repeatLabel.text!) { [weak self] (eventID, error) in
                            guard let _ = self, let eventID = eventID else { return }
                            var events = [String]()
                            if let value = UserDefaults.standard.array(forKey: UserDefaultKey.events) as? [String] {
                                events = value
                            }
                            events.append(eventID)
                            UserDefaults.standard.set(events, forKey: UserDefaultKey.events)
                        }
                    }
                    self.showAlert(title: StringConstants.appName, message: response.message, completion: { [unowned self] in
                        AppRouter.shared.moveToDashBoardScreen()

                    })
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
    }

    override func leftButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func repeatButtonAction(_ sender: Any) {
        let controller = RepeatViewController.instantiateFromStoryBoard()
        controller.selectedOption = self.repeatLabel.text!
        controller.handler = { [weak self] (value) in
            guard let self = self else { return }
            self.repeatLabel.text = value
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func allDaySwitchAction(_ sender: Any) {
    }

    @IBAction func startsButtonAction(_ sender: UIControl) {
        sender.isSelected = !sender.isSelected
        datePickerView.isHidden = !sender.isSelected
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.startDate = sender.date
        self.dateLabel.text = formatter.string(from: startDate)
    }

}
