
//  StringConstants.swift
//  Created by Trans V-BOX on 23/01/2020.
//  Copyright © 2020 Trans V-BOX. All rights reserved.

import Foundation
import UIKit

struct StringConstants {
    static let OK = "OK"
    static let cancel = "Cancel"
    static let chooseImage = "Choose Image"
    static let camera = "Camera"
    static let gallery = "Gallery"
    static let Yes = "Yes"
    static let save = "Save"
    static let no = "No"
    static let Logout = "Logout?"
    static let Bluetooth = "Bluetooth"
    static let advertising = "Advertising Bluetooth"
    static let title = "title"
    static let value = "value"
    static let showToogle = "showToogle"
//    static let appName = "Trans V"
    static let appName = "Attuned"
    static let warning = "Warning"
    static let cameraPermission = "You don't have camera"
    static let Myidealvoicewouldsound = "My ideal voice would sound"
    static let Currentlymyvoiceis = "Currently my voice is"
    static let pitch = "Pitch"
    static let control = "Control"
    static let comfort = "Comfort"
    static let consistency = "Consistency"
    static let authenticTrueVoice = "Authentic/True voice"
    static let upto = "You can select a maximum of"
    static let step7 = "Indicate whether you have\nthe following"
    static let next = "Next"
    static let finish = "Finish"
    static let enterEmail = "Please enter email"
    static let enterPassword = "Please enter password"
    static let enterName = "Please enter username"
    static let validEmail = "Please enter valid email"
    static let enterAccess = "Please enter Acsess Code"
    static let selectOrType = "Please select or type"
    static let provideInput = "Please provide input"
    static let successCode = "200"
    static let errorCode = "413"
    static let homework = "Homework"
    static let profile = "Profile"
    static let lessonLocked = "is locked"
    static let logoutMessage = "Are you sure you want to logout?"
    static let replay = "REPLAY"
    static let play = "PLAY"
    static let time = "Time"
    static let saveRecording = "Do you want to save this recording"
    static let updateRecording = "Do you want to update this recording"
    static let pushNotifications = "Push Notifications"
    static let reminder = "Reminder"
    static let contactUs = "Contact Us"
    static let passwordChange = "Password Change"
    static let logout = "Logout"
    static let recordingsData = ["Recording 1","Recording 2","Recording 3","Recording 4","Recording 5"]
    static let genderArray = ["Trans Female","Trans Male","Non-Binary","Gender Non-Conforming","Other",]
    static let rename = "Rename"
    static let delete = "Delete"
    static let deleteMessage = "Do you want to delete"
    static let newPassword = "Please enter new password"
    static let oldPassword = "Please enter old password"
    static let confirmPassword = "Please confirm password"
    static let agreeButtonMessage = "Please select the disclaimer clause"
    static let doesntMatch = "Password doesn't match"
    static let done = "Done"
    static let setCallNotification = "Schedule Reminder"
    static let disclaimer = "Disclaimer"
    static let never = "Never"
    static let everyDay = "Every Day"
    static let everyWeek = "Every Week"
    static let every2Weeks = "Every 2 Weeks"
    static let everyMonth = "Every Month"
    static let everyYear = "Every Year"
    static let repeats = "Repeat"
    static let share = "Share"
    static let callNotificationAdded = "Call notification added successfully"
    static let setCallReminder = "Do you want to set a call reminder for the same?"
    static let tapToPlayRecording = "Tap to Play Recording"
    static let tapToStartRecording = "Tap to Record"
    static let profileUpdated = "Your profile has been successfully updated"
    static let profileCreated = "Your profile has been successfully created"
    static let thankYou = "Thank You"
    static let lessonFeedBackSubmitted = "You are done with your Lesson task, please continue with your homework"
    static let homeFeedBackSubmitted = "You are done with Exercise, please continue further"
    static let listOfReminders = "List of Reminders"
    static let Profile_Settings = "Profile Settings"
    static let Notifications = "Notifications"
}


struct CellIdentifiers {
    static let HeaderTableViewCell = "HeaderTableViewCell"
    static let ProgressTableViewCell = "ProgressTableViewCell"
    static let OptionSelectionTableViewCell = "OptionSelectionTableViewCell"
    static let OptionHeaderTableViewCell = "OptionHeaderTableViewCell"
    static let OptionTypeTableViewCell = "OptionTypeTableViewCell"
    static let VoiceCollectionViewCell = "VoiceCollectionViewCell"
    static let VoiceTableViewCell = "VoiceTableViewCell"
    static let LessionsUserTableViewCell = "LessionsUserTableViewCell"
    static let LessionsHeaderTableViewCell = "LessionsHeaderTableViewCell"
    static let LessionTableViewCell = "LessionTableViewCell"
    static let RecordingsTableViewCell = "RecordingsTableViewCell"
    static let SettingsTableViewCell = "SettingsTableViewCell"
    static let LogoutTableViewCell = "LogoutTableViewCell"
    static let GenderTableViewCell = "GenderTableViewCell"
    static let WhiteCollectionViewCell = "WhiteCollectionViewCell"
    static let ReminderTableViewCell = "ReminderTableViewCell"
    static let NotificationTableViewCell = "NotificationTableViewCell"
}


struct UserDefaultKey {
    static let accessToken = "access_token"
    static let userModel = "userModel"
    static let isProfileCompleted = "isProfileCompleted"
    static let deviceToken = "deviceToken"
    static let events = "events"
    static let isCallNotificationEnabled = "isCallNotificationEnabled"
    static let doNotShow = "doNotShow"
}

struct SegueIdentifiers {
    
    static let pushToAccessCodeScreen = "PushToAccessCode"
    
}

struct ViewIdentifiers {
    static let accessCodeViewController = "AccessCodeViewController"
    static let disclaimerViewController = "DisclaimerViewController"
    static let onboardingViewController = "OnboardingViewController"
    static let onboardingContentViewController = "OnboardingContentViewController"
    static let signUpViewController = "SignUpViewController"
    static let signInViewController = "SignInViewController"
    static let getStartedViewController = "GetStartedViewController"
    static let profilePageViewController = "ProfilePageViewController"
    static let profileStep1ViewController = "ProfileStep1ViewController"
    static let profileStep2ViewController = "ProfileStep2ViewController"
    static let profileStep3ViewController = "ProfileStep3ViewController"
    static let profileStep4ViewController = "ProfileStep4ViewController"
    static let profileStep7ViewController = "ProfileStep7ViewController"
    static let TabBarViewController = "TabBarViewController"
    static let VoiceTrackerViewController = "VoiceTrackerViewController"
    static let RecordingsViewController = "RecordingsViewController"
    static let SettingsViewController = "SettingsViewController"
    static let LessionsViewController = "LessionsViewController"
    static let HomeWorkViewController = "HomeWorkViewController"
    static let ForgotPasswordViewController = "ForgotPasswordViewController"
    static let EmptyViewController = "EmptyViewController"
    static let ExercisePageViewController = "ExercisePageViewController"
    static let ExerciseFeedbackViewController = "ExerciseFeedbackViewController"
    static let TextExerciseViewController = "TextExerciseViewController"
    static let VideoExerciseViewController = "VideoExerciseViewController"
    static let FullScreenVideoViewController = "FullScreenVideoViewController"
    static let RecordVoiceViewController = "RecordVoiceViewController"
    static let ProfileSegmentViewController = "ProfileSegmentViewController"
    static let EditProfileViewController = "EditProfileViewController"
    static let ProfileSelectGenderViewController = "ProfileSelectGenderViewController"
    static let ChangePasswordViewController = "ChangePasswordViewController"
    static let CallNotificationViewController = "CallNotificationViewController"
    static let RepeatViewController = "RepeatViewController"
    static let ReminderListViewController = "ReminderListViewController"
    static let LessonCompletePopupViewController = "LessonCompletePopupViewController"
    static let NotificationsViewController = "NotificationsViewController"
    static let SaveRecordingViewController = "SaveRecordingViewController"
    static let AlertViewController = "AlertViewController"
    static let splashViewController = "SplashViewController"
}


struct Storyboard {
    static let main =  "Main"
    static let profile = "Profile"
    static let lessions = "Lessions"
    static let voiceTracker = "VoiceTracker"
    static let recordings = "Recordings"
    static let settings = "Settings"
}

struct CoreDBEntity {
    
}


struct NavigationTitle{
    static let myRecordings =  "My Recordings"
    static let settings = "Settings"
}

struct ImageConstants {
    static let callNotificationImage = UIImage(named: "call-notification")!
    static let pushNotificationImage = UIImage(named: "push-notification")!
    static let moreImage = UIImage(named: "more")!
    static let logoutImage = UIImage(named: "logout")!
    static let contactImage = UIImage(named: "contact us")!
    static let passwordChange = UIImage(named: "password change")!
    static let disclaimer = UIImage(named: "Disclaimer icon")!
    static let reminder = UIImage(named: "reminder-icon")!
}
