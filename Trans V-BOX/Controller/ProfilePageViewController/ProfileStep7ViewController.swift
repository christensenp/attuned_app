//
//  ProfileStep7ViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 3/3/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProfileStep7ViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.profileStep7ViewController
    static var storyBoardName: String = Storyboard.profile
    @IBOutlet weak var tableView: UITableView!
    let data: [ProfileStep3]  = [.header, .optionsType]
    var screen = [Screen]()
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index, value) in screen.enumerated() {
            if let answerArr = value.answers {
                for answer in answerArr {
                    if  let indexFound = value.question?.questionOptions?.firstIndex(where: {$0.questionOptionID == answer.questionOptionID}) {
                        screen[index].question?.questionOptions?[indexFound].isAnswer = true
                    }
                }
            }
        }
        tableView.estimatedSectionHeaderHeight = 1
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.registerCell(HeaderTableViewCell.cellIdentifier)
        tableView.registerCell(OptionHeaderTableViewCell.cellIdentifier)
        tableView.registerCell(OptionSelectionTableViewCell.cellIdentifier)
        
    }
    
    
    
    func saveAnswer(handler: @escaping EmptyAction) {
        var questionAnswer = [[String: Any]]()
        for data in screen {
            if let selectedAnswer = data.question?.questionOptions?.filter({$0.isAnswer == true}), selectedAnswer.count > 0 {
                for answer in selectedAnswer {
                    questionAnswer.append([APIKeys.questionId: data.questionID ?? "", APIKeys.questionOptionId: answer.questionOptionID ?? ""])
                }
            }
        }
        
        self.showLoading()
        let param: [String: Any] = [APIKeys.isCompleted: 1, APIKeys.answer: questionAnswer]
        let data = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        print(String(data: data, encoding: .utf8) ?? "")
        APIManager.shared.saveAnswer(param: param) { [unowned self] (response, status, error) -> (Void) in
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


extension ProfileStep7ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return screen.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (screen[section].question?.questionOptions?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionHeaderTableViewCell.cellIdentifier) as! OptionHeaderTableViewCell
            cell.countLabel.text = "\(StringConstants.upto) \(screen[indexPath.section].question?.maxAllowedAnswers ?? 0)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionSelectionTableViewCell.cellIdentifier, for: indexPath) as! OptionSelectionTableViewCell
            if let questionOptions = screen[indexPath.section].question?.questionOptions {
                cell.setUp(data: questionOptions[indexPath.row-1])
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch data[section] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.cellIdentifier) as! HeaderTableViewCell
            cell.labelTitle.text = StringConstants.step7
            return cell.contentView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch data[section] {
        case .header:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0  {
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

