//
//  LessionsHeaderTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 19/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class LessionsHeaderTableViewCell: UITableViewCell {

    static let cellIdentifier = CellIdentifiers.LessionsHeaderTableViewCell
    @IBOutlet weak var findYourVoiceImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
