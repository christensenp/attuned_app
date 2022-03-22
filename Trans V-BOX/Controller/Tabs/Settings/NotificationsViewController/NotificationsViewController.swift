//
//  NotificationsViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 19/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    static var storyBoardId: String = ViewIdentifiers.NotificationsViewController
    static var storyBoardName: String = Storyboard.settings
    @IBOutlet weak var tableView: UITableView!
    var notifications = [Notifications]()

    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.warningLabel.isHidden = true
        self.setLeftBarButtonItem(imageName: "back")
        self.title = StringConstants.Notifications
        self.navigationController?.isNavigationBarHidden = false
        tableView.registerCell(NotificationTableViewCell.cellIdentifier)
        self.getNotifications()
        // Do any additional setup after loading the view.
    }

    func getNotifications() {
        self.showLoading()
        APIManager.shared.getNotifications { [weak self] (response, status, error) -> (Void) in
            guard let self = self else { return }
            self.stopLoading()
            if let response = response as? NotificationModel {
                self.notifications = response.data ?? []
            }
            self.warningLabel.isHidden = !(self.notifications.count == 0)
            self.tableView.reloadData()
        }
    }

}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.cellIdentifier, for: indexPath) as! NotificationTableViewCell
        cell.setUp(model: notifications[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
