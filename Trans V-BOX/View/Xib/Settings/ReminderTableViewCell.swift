//
//  ReminderTableViewCell.swift
//  Trans V-BOX
//
//  Created by Gourav on 07/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    static let cellIdentifier = CellIdentifiers.ReminderTableViewCell
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var deleteHandler: EmptyAction!
    var switchHandler: CompletionWithStatus!
    var editReminderHandler: EmptyAction!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        self.switchHandler(sender.isOn)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        self.deleteHandler()
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.editReminderHandler()
    }

    func setUp(model: Reminder, deleteHandler: @escaping EmptyAction, switchHandler: @escaping CompletionWithStatus, editReminderHandler: @escaping EmptyAction) {
        self.deleteHandler = deleteHandler
        self.switchHandler = switchHandler
        self.editReminderHandler = editReminderHandler
        nameLabel.text = model.reminderName
        if let value = model.reminderTime?.value, let reminderTime = Double("\(value)") {
            let date = Date(timeIntervalSince1970: reminderTime)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy  hh:mm a"
            dateLabel.text = formatter.string(from: date)
        }
        if let status = model.status {
            switchButton.isOn = status
        }
    }
    
    
}
