//
//  ExerciseFeedbackViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 24/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ExerciseFeedbackViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.ExerciseFeedbackViewController
    static var storyBoardName: String = Storyboard.lessions
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var notButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var pageIndex = 0
    var lesson: Lesson!
    var handler: StringCompletion!
    var isHomework: Bool = false
    var homework: Homework?
    
    @IBOutlet weak var buttonContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if let isCompleted = homework?.isCompleted, isCompleted {
            self.setMessage(message: "\(StringConstants.thankYou)\n\n\(StringConstants.homeFeedBackSubmitted)")
        }else if let isFeedback = lesson.isFeedBack, !isHomework, isFeedback {
            self.setMessage(message: "\(StringConstants.thankYou)\n\n\(StringConstants.lessonFeedBackSubmitted)")
        } else {
            var excerciseName = ""
            if let name = homework?.name{
                excerciseName = name
            } else if let name = lesson.name {
                 excerciseName = name
            }
            messageLabel.text = "Do you feel \(excerciseName)\nwas helpful?"
            messageLabel.setCharacterSpacing(1.3, font: UIFont(name:Font.YuGothicMedium , size: 20))
        }
    }
    
    func setMessage(message: String) {
        messageLabel.text = message
        buttonContainerView.isHidden = true
        messageLabel.setCharacterSpacing(1.3, font: UIFont(name:Font.YuGothicBold , size: 20))
    }
    
    @IBAction func yesButtonAction(_ sender: Any) {
        self.submitFeedback(feedback: true)
    }
    
    @IBAction func noButtonAction(_ sender: Any) {
        self.submitFeedback(feedback: false)
    }
    
    func submitFeedback(feedback: Bool) {
        var param: [String: Any] = [APIKeys.lessonId: lesson.lessonID ?? "", APIKeys.feedBack: feedback]
        if let homework = homework {
            param[APIKeys.exerciseId] = homework.exerciseID ?? ""
        }
        self.showLoading()
        APIManager.shared.submitLessonFeedback(isHomework: isHomework, param: param) { [weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    if let homeWork = self.homework {
                        homeWork.isCompleted = true
                    }
                    self.lesson.isFeedBack = true
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        self.updateUI()
                    }
                    self.handler(response.message)
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
    }
    
    deinit {
        print("delloc ExerciseFeedbackViewController")
    }
    
}
