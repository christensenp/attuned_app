//
//  ProfileStep2ViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/28/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProfileStep2ViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.profileStep2ViewController
    static var storyBoardName: String = Storyboard.profile
    
    @IBOutlet weak var sheButton: UIButton!
    @IBOutlet weak var herButton: UIButton!
    @IBOutlet weak var hersButton: UIButton!
    
    @IBOutlet weak var heButton: UIButton!
    @IBOutlet weak var himButton: UIButton!
    @IBOutlet weak var hisButton: UIButton!
    
    @IBOutlet weak var theyButton: UIButton!
    @IBOutlet weak var themButton: UIButton!
    @IBOutlet weak var theirsButton: UIButton!
    
    @IBOutlet weak var femaleGenderTextField: UITextField!
    @IBOutlet weak var maleGenderTextField: UITextField!
    @IBOutlet weak var otherGenderTextField: UITextField!
    
    var sheHeTheyButtons = [UIButton]()
    var herHimThemButtons = [UIButton]()
    var hersHisTheirsButtons = [UIButton]()
    var screen = [Screen]()
    var sheIndex = -1
    var heIndex = -1
    var theyIndex = -1
    var hasData = false
    override func viewDidLoad() {
        super.viewDidLoad()
        sheHeTheyButtons = [sheButton, heButton, theyButton]
        herHimThemButtons = [herButton, himButton, themButton]
        hersHisTheirsButtons =  [hersButton, hisButton, theirsButton]
        if let index = screen.firstIndex(where: { $0.question?.questionType == QuesType.mcq.rawValue }) {
            if let answerArr = screen[index].answers {
                for answer in answerArr {
                    if let indexFound = screen[index].question?.questionOptions?.firstIndex(where: {$0.questionOptionID == answer.questionOptionID}) {
                        if let button = self.view.viewWithTag(indexFound + 1) as? UIButton {
                            button.isSelected = true
                            screen[0].question!.questionOptions![button.tag - 1].isAnswer = true
                            button.titleLabel?.font = UIFont(name: Font.YuGothicBold, size: 16)
                            if sheHeTheyButtons.contains(button) {
                                sheIndex = indexFound
                            } else if herHimThemButtons.contains(button) {
                                heIndex = indexFound
                            } else if hersHisTheirsButtons.contains(button) {
                                theyIndex = indexFound
                            }
                        }
                    } else {
                        if let textArr = answer.otherAnswer?.components(separatedBy: "/") {
                            femaleGenderTextField.text = textArr.safe(index: 0) as? String
                            maleGenderTextField.text = textArr.safe(index: 1)  as? String
                            otherGenderTextField.text = textArr.safe(index: 2) as? String
                        }
                    }
                }
                
               
                
            }
        }
    }
    
    @IBAction func sheHeTheyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectUnSelectButton(sender, array: sheHeTheyButtons)
        sheIndex = sender.tag - 1
    }
    
    @IBAction func herHimThemButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectUnSelectButton(sender, array: herHimThemButtons)
        heIndex = sender.tag - 1
    }
    
    @IBAction func hersHisTheirsButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectUnSelectButton(sender, array: hersHisTheirsButtons)
        theyIndex = sender.tag - 1
    }
    
    func selectUnSelectButton(_ sender: UIButton? = nil, array: [UIButton]) {
        for button in array {
            button.isSelected = false
            button.titleLabel?.font = UIFont(name: Font.YuGothicRegular, size: 16)
            screen[0].question!.questionOptions![button.tag - 1].isAnswer = false
            if let sender = sender {
                if sender == button {
                    hasData = true
                    maleGenderTextField.text = ""
                    femaleGenderTextField.text = ""
                    otherGenderTextField.text = ""
                    button.isSelected = true
                    screen[0].question!.questionOptions![button.tag - 1].isAnswer = true
                    button.titleLabel?.font = UIFont(name: Font.YuGothicBold, size: 16)
                }
            }
        }
    }
    
    func saveAnswer(handler: @escaping EmptyAction) {
        var message = ""
        if sheIndex == -1 && heIndex == -1 && theyIndex == -1 && femaleGenderTextField.text!.trim().isEmpty &&  maleGenderTextField.text!.trim().isEmpty  &&  otherGenderTextField.text!.trim().isEmpty {
            message = StringConstants.selectOrType
        }
        
        if !message.isEmpty {
            self.showWarningAlert(title: StringConstants.appName, message: message)
            return
        }
        
        
        if let index = screen.firstIndex(where: { $0.question?.questionType == QuesType.mcq.rawValue }) {
            var questionAnswer = [[String: String]]()
            let filter = screen[index].question?.questionOptions?.filter {$0.isAnswer == true}
            if let filter = filter,  filter.count > 0 {
                for value in filter {
                    questionAnswer.append([APIKeys.questionId: screen[index].questionID!, APIKeys.questionOptionId: value.questionOptionID ?? ""])
                }
            } else {
                let otherAnswer = String(format:"%@/%@/%@", femaleGenderTextField.text!.trim(), maleGenderTextField.text!.trim(), otherGenderTextField.text!.trim())
                questionAnswer = [[APIKeys.questionId: screen[index].questionID ?? "", APIKeys.otherAnswer: otherAnswer]]
            }
            
            self.showLoading()
            let param: [String: Any] = [APIKeys.isCompleted: 0, APIKeys.answer: questionAnswer]
            let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            print(String(data: data, encoding: .utf8) ?? "")
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
    
    func resetData() {
        self.selectUnSelectButton(array: sheHeTheyButtons)
        self.selectUnSelectButton(array: herHimThemButtons)
        self.selectUnSelectButton(array: hersHisTheirsButtons)
        sheIndex = -1
        heIndex = -1
        theyIndex = -1
        if let index = screen.firstIndex(where: { $0.question?.questionType == QuesType.mcq.rawValue }), let questionOptions = screen[index].question?.questionOptions {
            for i in 0..<questionOptions.count {
                screen[index].question?.questionOptions?[i].isAnswer = false
            }
        }
        hasData = false
    }
    
}


extension ProfileStep2ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: .letters) != nil || string == " " || string == "" {
            let characterSet = CharacterSet.letters
            if string.rangeOfCharacter(from: characterSet.inverted) != nil {
                return false
            }
            if hasData { // to reset data if user type in textfield
                self.resetData()
            }
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return false
        }
    }
}
