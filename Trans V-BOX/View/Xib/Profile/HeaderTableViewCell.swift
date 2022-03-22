//
//  HeaderTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 3/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    static let cellIdentifier = CellIdentifiers.HeaderTableViewCell
    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
