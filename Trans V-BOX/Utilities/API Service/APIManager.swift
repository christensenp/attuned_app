//
//  APIManager.swift
//  Ideal Diet
//
//  Created by Gourav on 02/09/19.
//  Copyright © 2019 Gourav. All rights reserved.
//

import UIKit
typealias DataCompletionBlock = (_ data : Any? ,_ statusCode:Int, _ error:String?) -> (Void)
class APIManager {
    static let shared = APIManager()
    
    func login(param:[String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.login, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func signUp(param:[String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.multiPartPostRequest(baseUrl: APIConstants.register, params: param, type: .post, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func editProfile(param:[String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.multiPartPostRequest(baseUrl: APIConstants.editProfile, params: param, type: .post, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func forgortPassword(param:[String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.forgotPassword, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func accessCode(param:[String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.verifyAccessCode, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func getQuestionAnswers(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.getQuestionAnswers, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = QuestionAnswerModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func saveAnswer(param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.saveAnswer, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func getLessions(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.getLessonList, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = LessonModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func submitLessonFeedback(isHomework: Bool, param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        let baseURL = isHomework ? APIConstants.submitExerciseFeedback : APIConstants.submitLessonFeedback
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: baseURL, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func getHomeWork(lessonID: String, completionHandler: @escaping DataCompletionBlock) {
        let baseURL = "\(APIConstants.getHomeworkContentList)\(lessonID)"
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: baseURL, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = HomeWorkModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func getRecordingTask(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.recordingTaskList, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = RecordingTaskModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func uploadAudio(param:[String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.multiPartPostRequest(isAudio: true, baseUrl: APIConstants.saveRecording, params: param, type: .post, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = SaveRecordingModel.init(object: response)
                if let model = model {
                    if String(describing: model.code.value) == StringConstants.successCode, let recordingName = model.data?.recordingName  {
                        AppDelegate.sharedDelegate().window?.makeToast("\(recordingName) saved successfully.")
                    } else {
                        AppDelegate.sharedDelegate().window?.makeToast(model.message)
                    }
                }
                completionHandler(model, 200, nil)
            } else {
                AppDelegate.sharedDelegate().window?.makeToast(error?.localizedDescription ?? "")
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func getRecordings(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.userRecordingList, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserRecordingsModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func updateRecordingName(param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.updateRecordingName, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func deleteUserRecording(recordListId: String, completionHandler: @escaping DataCompletionBlock) {
        let baseURL = "\(APIConstants.deleteUserRecording)\(recordListId)"
        HTTPClient.shared?.httpRequest(type: .delete, baseUrl: baseURL, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func changePassword(param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.changePassword, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func updateDeviceToken(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.updateDeviceToken, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func logout(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.logout, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func updateSettings(param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.settings, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func getSettings(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.getSettings, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = SettingsModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func downloadAudioFile(audioURL:String, completionHandler: @escaping DataCompletionBlock) {
        if let url = URL(string: audioURL) {
            HTTPClient.shared?.downloadFile(audioURL: url, completionBlock: { (response, status, error) -> (Void) in
                completionHandler(response, status, error)
            })
        } else {
            completionHandler(nil, 200, nil)
        }
    }
    
    func setReminder(isUpdate: Bool, param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        let url = isUpdate ? APIConstants.editReminder : APIConstants.setReminder
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: url, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func getReminders(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.reminderList, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = ReminderModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
    
    func deleteReminder(reminderID:String, completionHandler: @escaping DataCompletionBlock) {
        let baseURL = "\(APIConstants.deleteReminder)\(reminderID)"
        HTTPClient.shared?.httpRequest(type: .delete, baseUrl: baseURL, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }

    func editReminder(param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.editReminder, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }

    func changeReminderStatus(param: [String: Any], completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .post, baseUrl: APIConstants.changeReminderStatus, params: param, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = UserModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }


    func getNotifications(completionHandler: @escaping DataCompletionBlock) {
        HTTPClient.shared?.httpRequest(type: .get, baseUrl: APIConstants.notificationList, params: nil, completionBlock: { (response, status, error) -> (Void) in
            if let response = response {
                let model = NotificationModel.init(object: response)
                completionHandler(model, 200, nil)
            } else {
                completionHandler(nil, 400, error?.localizedDescription)
            }
        })
    }
}
