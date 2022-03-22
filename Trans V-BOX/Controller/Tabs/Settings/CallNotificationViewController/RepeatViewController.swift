//
//  RepeatViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 21/04/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class RepeatViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.RepeatViewController
    static var storyBoardName: String = Storyboard.settings
    var data = [StringConstants.never, StringConstants.everyDay, StringConstants.everyWeek, StringConstants.everyMonth, StringConstants.everyYear]
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = -1
    var selectedOption = StringConstants.never
    var handler: StringCompletion!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = StringConstants.repeats
        self.setUPNavigationBarColor(isClearColor: false)
        self.setLeftBarButtonItem(imageName: "back")
        if let index = data.firstIndex(where: {$0 == selectedOption}) {
            selectedIndex = index
        }
        // Do any additional setup after loading the view.
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

extension RepeatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        cell.selectionStyle = .none
        cell.accessoryType = (indexPath.row == selectedIndex) ? UITableViewCell.AccessoryType.checkmark :  UITableViewCell.AccessoryType.none
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        self.handler(data[indexPath.row])
    }
}
