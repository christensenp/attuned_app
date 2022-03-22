//
//  ProfileStep3ViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/28/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

struct Options {
    let name: String
    var value: Bool
}

class ProfileStep3ViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.profileStep3ViewController
    static var storyBoardName: String = Storyboard.profile
    @IBOutlet weak var tableView: UITableView!
    var screen = [Screen]()
    var otherTypeMessage: String = ""
    var questionOptions = [QuestionOption]()
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index, value) in screen.enumerated() {
            if let answerArr = value.answers {
                for answer in answerArr {
                    if let questionType = value.question?.questionType, questionType == QuesType.slider.rawValue {
                        screen[index].question?.midValue?.value = answer.otherAnswer ?? 0
                    } else{
                        if  let indexFound = value.question?.questionOptions?.firstIndex(where: {$0.questionOptionID == answer.questionOptionID}) {
                            screen[index].question?.questionOptions?[indexFound].isAnswer = true
                        } else {
                            self.otherTypeMessage = answer.otherAnswer ?? ""
                        }
                    }
                }
            }
        }
        tableView.estimatedSectionHeaderHeight = 1
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.registerCell(HeaderTableViewCell.cellIdentifier)
        tableView.registerCell(ProgressTableViewCell.cellIdentifier)
        tableView.registerCell(OptionHeaderTableViewCell.cellIdentifier)
        tableView.registerCell(OptionSelectionTableViewCell.cellIdentifier)
        tableView.registerCell(OptionTypeTableViewCell.cellIdentifier)
        
        
        // Do any additional setup after loading the view.
    }
    
    func saveAnswer(handler: @escaping EmptyAction) {
        var questionAnswer = [[String: Any]]()
        for data in screen {
            if let questionType = data.question?.questionType, questionType == QuesType.mcq.rawValue {
                if let selectedAnswer = data.question?.questionOptions?.filter({$0.isAnswer == true}), selectedAnswer.count > 0 {
                    for answer in selectedAnswer {
                        questionAnswer.append([APIKeys.questionId: data.questionID ?? "", APIKeys.questionOptionId: answer.questionOptionID ?? ""])
                    }
                } else if !otherTypeMessage.trim().isEmpty {
                    questionAnswer.append([APIKeys.questionId: data.questionID ?? "", APIKeys.otherAnswer: otherTypeMessage])
                }
            } else {
                questionAnswer.append([APIKeys.questionId: data.questionID ?? "", APIKeys.otherAnswer: "\(data.question?.midValue?.value ?? 0)"])
            }
        }
        
        self.showLoading()
        let param: [String: Any] = [APIKeys.isCompleted: 0, APIKeys.answer: questionAnswer]
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

extension ProfileStep3ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return screen.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let questionType = screen[section].question?.questionType ?? ""
        switch questionType {
        case QuesType.mcq.rawValue:
            return (screen[section].question?.questionOptions?.count ?? 0) + 2
        case QuesType.slider.rawValue:
            return (screen[section].question?.questionOptions?.count ?? 0)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let questionType = screen[indexPath.section].question?.questionType ?? ""
        if questionType == QuesType.mcq.rawValue {
            let questionOptions = (screen[indexPath.section].question?.questionOptions?.count ?? 0) + 2
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OptionHeaderTableViewCell.cellIdentifier, for: indexPath) as! OptionHeaderTableViewCell
                cell.countLabel.text = "\(StringConstants.upto) \(screen[indexPath.section].question?.maxAllowedAnswers ?? 0)"
                return cell
            } else if indexPath.row == questionOptions - 1  {
                let cell = tableView.dequeueReusableCell(withIdentifier: OptionTypeTableViewCell.cellIdentifier) as! OptionTypeTableViewCell
                cell.setUP(text: otherTypeMessage, handler: { [unowned self] text in
                    self.otherTypeMessage = text
                })
                return cell
            } else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: OptionSelectionTableViewCell.cellIdentifier, for: indexPath) as! OptionSelectionTableViewCell
                if let questionOptions = screen[indexPath.section].question?.questionOptions?[indexPath.row-1] {
                    cell.setUp(data: questionOptions)
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProgressTableViewCell.cellIdentifier) as! ProgressTableViewCell
            cell.setUP(model: screen[indexPath.section].question, progressClosure: { [unowned self] (progress) in
                self.screen[indexPath.section].question?.midValue?.value =  progress
            })
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let questionType = screen[section].question?.questionType ?? ""
        switch questionType {
        case QuesType.mcq.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.cellIdentifier) as! HeaderTableViewCell
            return cell.contentView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let questionType = screen[section].question?.questionType ?? ""
        switch questionType {
        case QuesType.mcq.rawValue:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionType = screen[indexPath.section].question?.questionType ?? ""
        let questionOptions = (screen[indexPath.section].question?.questionOptions?.count ?? 0) + 2
        if questionType == QuesType.mcq.rawValue {
            if indexPath.row > 0  &&  indexPath.row < questionOptions - 1  {
                let selectedAnswer = screen[indexPath.section].question!.questionOptions!.filter({$0.isAnswer == true})
                if let maxAllowedAnswers = screen[indexPath.section].question?.maxAllowedAnswers {
                    let isSelected = screen[indexPath.section].question!.questionOptions![indexPath.row-1].isAnswer
                    if selectedAnswer.count < maxAllowedAnswers ||  isSelected  {
                        screen[indexPath.section].question!.questionOptions![indexPath.row-1].isAnswer = !isSelected
                        tableView.reloadData()
                    } else {
                        self.showWarningAlert(title: StringConstants.appName, message: "\(StringConstants.upto) \(maxAllowedAnswers)")
                    }
                }
            }
        }
    }
    
}
