//
//  NotificationTableViewCell.swift
//  Trans V-BOX
//
//  Created by Gourav on 19/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    static let cellIdentifier = CellIdentifiers.NotificationTableViewCell
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setUp(model: Notifications) {
        nameLabel.text = model.title
        descLabel.text = model.message
        dateLabel.text = model.createdAt?.getDateFromString()
    }
    
}
