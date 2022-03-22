//
//  ProfileStep1ViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/28/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProfileStep1ViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.profileStep1ViewController
    static var storyBoardName: String = Storyboard.profile
    
    @IBOutlet weak var transFemaleButton: UIButton!
    @IBOutlet weak var transMaleButton: UIButton!
    @IBOutlet weak var nonBinayButtonAction: UIButton!
    @IBOutlet weak var genderNonConformingButton: UIButton!
    @IBOutlet weak var otherButtonAction: UIButton!
    @IBOutlet weak var typeHereTextField: UITextField!
    @IBOutlet weak var otherTextFieldView: UIView!
    var genderButtons = [UIButton]()
    var screen = [Screen]()
    var selectedIndex: Int = 0
    var selectedTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherButtonAction.isHidden = true
        typeHereTextField.delegate = self
        transFemaleButton.isSelected = true
        otherTextFieldView.isHidden = true
        genderButtons = [transFemaleButton, transMaleButton, nonBinayButtonAction, genderNonConformingButton, otherButtonAction]
        selectUnselectButton(transFemaleButton)
        
        if let index = screen.firstIndex(where: { $0.question?.questionType == QuesType.radio.rawValue }) {
            if let answerArr = screen[index].answers {
                for answer in answerArr {
                    if let indexFound = screen[index].question?.questionOptions?.firstIndex(where: {$0.questionOptionID == answer.questionOptionID}) {
                        self.selectedTitle = screen[index].question?.questionOptions?[indexFound].value ?? ""
                        self.selectedIndex = indexFound
                        let button = getButton(forTitle: self.selectedTitle)
                        if button == otherButtonAction {
                            self.selectUnselectButton(button)
                            self.typeHereTextField.text = answer.otherAnswer ?? ""
                            self.otherTextFieldView.isHidden = false
                        } else {
                            self.selectUnselectButton(button)
                        }
                        
                    } else {
                        self.selectUnselectButton(otherButtonAction)
                        self.typeHereTextField.text = answer.otherAnswer ?? ""
                        self.otherTextFieldView.isHidden = false
                    }
                }
            }
        }
        otherButtonAction.isHidden = true
    }
    
    func getButton(forTitle title:String) -> UIButton {
        switch title {
        case "Trans Female":
            return transFemaleButton
        case "Gender Non-Conforming":
            return genderNonConformingButton
        case "Trans Male":
            return transMaleButton
        case "Non-Binary":
            return nonBinayButtonAction
        default:
            return otherButtonAction
        }
    }
    
    @IBAction func transFemaleButtonAction(_ sender: UIButton) {
        selectUnselectButton(sender)
    }
    
    @IBAction func transMaleButtonAction(_ sender: UIButton) {
        selectUnselectButton(sender)
    }
    
    @IBAction func nonBinaryButtonAction(_ sender: UIButton) {
        selectUnselectButton(sender)
    }
    @IBAction func genderConformingButtonAction(_ sender: UIButton) {
        selectUnselectButton(sender)
    }
    
    @IBAction func otherButtonAction(_ sender: UIButton) {
        selectUnselectButton(sender)
        otherTextFieldView.isHidden = false
    }
    
    func selectUnselectButton(_ sender: UIButton) {
        otherTextFieldView.isHidden = true
        for button in genderButtons {
            button.isSelected = false
            button.backgroundColor = UIColor.clear
            if sender == button {
                selectedIndex = button.tag - 1
                selectedTitle = button.title(for: .normal) ?? ""
                button.isSelected = true
                button.backgroundColor = BUTTONTHEMECOLOR
            }
        }
    }
    
    func saveAnswer(handler: @escaping EmptyAction) {
        if let index = screen.firstIndex(where: { $0.question?.questionType == QuesType.radio.rawValue }) {
            var questionAnswer = [String: Any]()
            questionAnswer[APIKeys.questionId] = screen[index].questionID ?? ""
            if let options = screen[index].question?.questionOptions {
                if let answerIndex = options.firstIndex(where: {$0.value == selectedTitle}){
                    selectedIndex = answerIndex
                }
                
                
                if selectedIndex > options.count - 1 {
                    if typeHereTextField.text!.trim().isEmpty {
                        self.showWarningAlert(title: StringConstants.appName, message: StringConstants.provideInput)
                        return
                    }
                    questionAnswer[APIKeys.otherAnswer] = typeHereTextField.text!.trim()
                } else {
                    questionAnswer[APIKeys.questionOptionId] = screen[index].question?.questionOptions?[selectedIndex].questionOptionID ?? ""
                }
            }
            self.showLoading()
            let param: [String: Any] = [APIKeys.isCompleted: 0, APIKeys.answer: [questionAnswer]]
            APIManager.shared.saveAnswer(param: param) { [weak self] (response, status, error) -> (Void) in
                guard let self = self else { return }
                self.stopLoading()
                if let response = response as? UserModel {
                    if String(describing: response.code.value) == StringConstants.successCode {
                        handler()
                    } else {
                        self.showWarningAlert(title: StringConstants.appName, message: response.message)
                    }
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
                }
            }
        }
    }
    
}

extension ProfileStep1ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: .letters) != nil || string == " " || string == "" {
            return true
        } else {
            return false
        }
    }
}
