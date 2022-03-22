//
//  LessionsViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 19/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

struct Lession {
    let name: String
    let color: UIColor
    let image: String
    let isLocked: Bool
}

class LessionsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    static var storyBoardId: String = ViewIdentifiers.LessionsViewController
    static var storyBoardName: String = Storyboard.lessions
    let data: [Lessions] = [.user, .header, .lessions]
    var lessons = [Lesson]()
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(LessionsUserTableViewCell.cellIdentifier)
        tableView.registerCell(LessionsHeaderTableViewCell.cellIdentifier)
        tableView.registerCell(LessionTableViewCell.cellIdentifier)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.showLoading()
        self.getLessons()
        // Do any additional setup after loading the view.
    }
    
    @objc func pullToRefresh() {
        self.refreshControl.endRefreshing()
        self.showLoading()
        self.getLessons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getLessons() {
        APIManager.shared.getLessions { [weak self](response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            
            if let response = response as? LessonModel {
                self.lessons = response.data?.lessons ?? []
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "Main")
            }
            self.tableView.reloadData()
        }
    }
}

extension LessionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch data[section] {
        case .user, .header:
            return 1
        default:
            return lessons.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch data[indexPath.section] {
        case .user:
            let cell = tableView.dequeueReusableCell(withIdentifier: LessionsUserTableViewCell.cellIdentifier, for: indexPath) as! LessionsUserTableViewCell
            cell.setUP()
            cell.imageTapped = {
                let segmentViewController = ProfileSegmentViewController.instantiateFromStoryBoard()
                self.push(segmentViewController)
            }
            return cell
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: LessionsHeaderTableViewCell.cellIdentifier, for: indexPath) as! LessionsHeaderTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: LessionTableViewCell.cellIdentifier, for: indexPath) as!
            LessionTableViewCell
            cell.setUp(model: lessons[indexPath.row], colorCode:  Colors.colors[indexPath.row % 5])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data[indexPath.section] == .lessions {
            if let isEnabled = lessons[indexPath.row].isEnabled, isEnabled {
                let controller = ExercisePageViewController .instantiateFromStoryBoard()
                controller.dismissHandler = {[weak self] in
                    guard let self = self else {return}
                    self.getLessons()
                }
                self.definesPresentationContext = true
                controller.colorCode = Colors.colors[indexPath.row % 5]
                controller.lesson = lessons[indexPath.row]
                controller.modalPresentationStyle = .overCurrentContext
                self.present(controller, animated: true, completion: nil)
            } else {
                self.showToast(message: "\(lessons[indexPath.row].name ?? "") \(StringConstants.lessonLocked)")
            }
        }
    }
}
