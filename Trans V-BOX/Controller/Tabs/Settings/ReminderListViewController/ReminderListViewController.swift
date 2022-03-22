//
//  ReminderListViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 07/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ReminderListViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.ReminderListViewController
    static var storyBoardName: String = Storyboard.settings
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var warningLabel: UILabel!
    var reminders = [Reminder]()
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setLeftBarButtonItem(imageName: "back")
        self.title = StringConstants.listOfReminders
        warningLabel.isHidden = true
        tableView.registerCell(ReminderTableViewCell.cellIdentifier)
        self.showLoading()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControl(_ :)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getReminderList()
    }

    @objc func refreshControl(_ sender: UIRefreshControl) {
        self.getReminderList()
    }

}


//MARK: - UITableView Delegate and DataSource Methods
extension ReminderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.cellIdentifier) as! ReminderTableViewCell
        cell.setUp(model: reminders[indexPath.row], deleteHandler: { [weak self] in
            guard let self = self else {return}
            self.deleteReminder(index: indexPath.row)
            }, switchHandler: { [weak self] (status) in
                guard let self = self else {return}
                self.changeReminderStatus(index: indexPath.row, status: status)
            }, editReminderHandler: { [weak self] in
                guard let self = self else {return}
                let controller = CallNotificationViewController.instantiateFromStoryBoard()
                controller.reminder = self.reminders[indexPath.row]
                let root = UINavigationController(rootViewController: controller)
                root.modalPresentationStyle = .fullScreen
                self.present(root, animated: true, completion: nil)
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
}

extension ReminderListViewController {

    func deleteReminder(index: Int) {
        self.showAlertYesOrNo(title: StringConstants.delete, message:  "\(StringConstants.deleteMessage) \(self.reminders[index].reminderName ?? "")?", completion: {[weak self ] in
            guard let self = self else { return }
            self.showLoading()
            APIManager.shared.deleteReminder(reminderID: self.reminders[index].id ?? "") { [weak self](response, status, error) -> (Void) in
                guard let self = self else {return}
                if let response = response as? UserModel {
                    if String(describing: response.code.value) == StringConstants.successCode {
                        self.getReminderList()
                    } else {
                        self.stopLoading()
                        self.showWarningAlert(title: StringConstants.appName, message: response.message)
                    }
                } else {
                    self.stopLoading()
                    self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
                }
            }
        })

    }

    func getReminderList() {
        APIManager.shared.getReminders { [weak self](response, status, error) -> (Void) in
            guard let self = self else { return }
            self.stopLoading()
            self.refreshControl.endRefreshing()
            if let response = response as? ReminderModel {
                self.reminders = response.data ?? []
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
            DispatchQueue.main.async {
                self.warningLabel.isHidden = !(self.reminders.count == 0)
                self.tableView.reloadData()
            }
        }
    }

    func changeReminderStatus(index: Int, status: Bool) {
        self.showLoading()
        let param: [String: Any] = [APIKeys.reminderId: self.reminders[index].id ?? "", APIKeys.status: status]
        APIManager.shared.changeReminderStatus(param:param) { [weak self](response, status, error) -> (Void) in
            guard let self = self else {return}
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    self.getReminderList()
                } else {
                    self.stopLoading()
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.stopLoading()
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
    }
}

//MARK: - SearchBar Delegate Methods
extension ReminderListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        if searchText.trim().isEmpty {
        //            self.recordings = self.data
        //        } else {
        //            let filteredArray = self.data.filter { $0.recordingName!.localizedCaseInsensitiveContains(searchText.trim()) }
        //            self.recordings = filteredArray
        //        }
        //        tableView.reloadData()
    }
}
