//
//  ProfileStep4ViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 04/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProfileStep4ViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.profileStep4ViewController
    static var storyBoardName: String = Storyboard.profile
    @IBOutlet weak var tableView: UITableView!
    var data = [[String: Any]]()
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
        tableView.registerCell(VoiceTableViewCell.cellIdentifier)
        // Do any additional setup after loading the view.
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
        let param: [String: Any] = [APIKeys.isCompleted: 0, APIKeys.answer: questionAnswer]
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ProfileStep4ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return screen.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VoiceTableViewCell.cellIdentifier, for: indexPath) as! VoiceTableViewCell
        if let questionOptions = screen[indexPath.section].question?.questionOptions {
            cell.setUp(options: questionOptions, handler: {[unowned self] (index) in
                for i in 0..<self.screen[indexPath.section].question!.questionOptions!.count {
                    self.screen[indexPath.section].question!.questionOptions![i].isAnswer = false
                }
                self.screen[indexPath.section].question!.questionOptions![index.row].isAnswer = !self.screen[indexPath.section].question!.questionOptions![index.row].isAnswer
                tableView.reloadData()
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.cellIdentifier) as! HeaderTableViewCell
        cell.labelTitle.text = screen[section].question?.question ?? ""
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
