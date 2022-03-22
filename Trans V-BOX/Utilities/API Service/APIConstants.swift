//
//  APIConstants.swift
//  MPB
//
//  Created by Gourav on 17/07/19.
//  Copyright © 2019 Gourav. All rights reserved.
//

import Foundation

struct APIConstants {
    static let DOMAIN = "https://app.attunedvoice.com/"
//    static let DOMAIN = "https://cornellapp.mobikasa.net/"
    static let BASEURL = APIConstants.DOMAIN + "api/v1/"
    static let register = APIConstants.BASEURL + "signUp"
    static let editProfile = APIConstants.BASEURL + "editProfile"
    static let login = APIConstants.BASEURL + "login"
    static let verifyAccessCode = APIConstants.BASEURL + "verifyAccessCode"
    static let getQuestionAnswers = APIConstants.BASEURL + "getQuestionAnswers"
    static let saveAnswer = APIConstants.BASEURL + "saveAnswer"
    static let forgotPassword = APIConstants.BASEURL + "forgotPassword"
    static let getLessonList = APIConstants.BASEURL + "getLessonList"
    static let submitLessonFeedback = APIConstants.BASEURL + "submitLessonFeedback"
    static let getHomeworkContentList = APIConstants.BASEURL + "getHomeworkContentList/"
    static let submitExerciseFeedback = APIConstants.BASEURL + "submitExerciseFeedback"
    static let recordingTaskList = APIConstants.BASEURL + "recordingTaskList"
    static let saveRecording = APIConstants.BASEURL + "saveRecording"
    static let userRecordingList = APIConstants.BASEURL + "userRecordingList"
    static let updateRecordingName = APIConstants.BASEURL + "updateRecordingName"
    static let deleteUserRecording = APIConstants.BASEURL + "deleteUserRecording/"
    static let changePassword = APIConstants.BASEURL + "changePassword"
    static let updateDeviceToken = APIConstants.BASEURL + "updateDeviceToken"
    static let logout = APIConstants.BASEURL + "logout"
    static let settings = APIConstants.BASEURL + "settings"
    static let getSettings = APIConstants.BASEURL + "getSettings"
    static let reminderList = APIConstants.BASEURL + "reminderList"
    static let setReminder = APIConstants.BASEURL + "setReminder"
    static let deleteReminder = APIConstants.BASEURL + "deleteReminder/"
    static let editReminder = APIConstants.BASEURL + "editReminder"
    static let changeReminderStatus = APIConstants.BASEURL + "changeReminderStatus"
    static let notificationList = APIConstants.BASEURL + "notificationList"

}


struct WebViewURLs {
    
}

struct API {
    
}

struct APIKeys {
    static let email = "email"
    static let password = "password"
    static let message = "message"
    static let name = "name"
    static let telephoneNumber = "telephoneNumber"
    static let admin = "admin"
    static let image = "image"
    static let accessCode = "accessCode"
    static let answer = "answer"
    static let questionId = "questionId"
    static let questionOptionId = "questionOptionId"
    static let otherAnswer = "otherAnswer"
    static let isCompleted = "isCompleted"
    static let lessonId = "lessonId"
    static let feedBack = "feedBack"
    static let exerciseId = "exerciseId"
    static let recordingTaskId = "recordingTaskId"
    static let recordingName = "recordingName"
    static let avgFrequency = "avgFrequency"
    static let file = "file"
    static let recordingListId = "recordingListId"
    static let oldPassword = "oldPassword"
    static let newPassword = "newPassword"
    static let isPushNotificationEnabled = "isPushNotificationEnabled"
    static let isCallNotificationEnabled = "isCallNotificationEnabled"
    static let minFrequency = "minFrequency"
    static let maxFrequency = "maxFrequency"
    static let reminderTime = "reminderTime"
    static let repeatType = "repeatType"
    static let status = "status"
    static let reminderId = "reminderId"
    static let isAllDay = "isAllDay"
    static let count = "count"
    static let type = "type"
    
}


