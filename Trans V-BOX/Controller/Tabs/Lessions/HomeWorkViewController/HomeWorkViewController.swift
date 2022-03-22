//
//  HomeWorkViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 20/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class HomeWorkViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.HomeWorkViewController
    static var storyBoardName: String = Storyboard.lessions
    @IBOutlet weak var tableView: UITableView!
    var homeworkData: HomeworkData!
    var lesson: Lesson!
    var colorCode: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = StringConstants.homework
        self.navigationController?.isNavigationBarHidden = false
        self.setLeftBarButtonItem(imageName: "back")
        tableView.registerCell(LessionTableViewCell.cellIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func leftButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("delloc HomeWorkViewController")
    }
}


extension HomeWorkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeworkData.homework?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessionTableViewCell.cellIdentifier, for: indexPath) as! LessionTableViewCell
        if let model = self.homeworkData.homework?[indexPath.row] {
            cell.setUp(model: model, colorCode: self.colorCode)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let isEnabled = homeworkData.homework?[indexPath.row].isEnabled, isEnabled {
            let homework = self.homeworkData.homework ?? []
            let controller = ExercisePageViewController.instantiateFromStoryBoard()
            controller.isHomeWorkViewHidden = true
            controller.homework = homework[indexPath.row]
            controller.lesson = lesson
            controller.isLastHomeWork = (indexPath.row ==  homework.count - 1)
            controller.handler = { [weak self] in
                guard let self = self else {return}
                let index = indexPath.row + 1
                homework[indexPath.row].isCompleted = true
                if indexPath.row + 1 < homework.count {
                    homework[index].isEnabled = true
                    self.tableView.reloadData()
                }
            }
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)
        } else {
            let homework = self.homeworkData.homework ?? []
            self.showToast(message: "\(homework[indexPath.row].name ?? "") \(StringConstants.lessonLocked)")
        }
    }
    
}
