//
//  OptionSelectionTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 3/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class OptionSelectionTableViewCell: UITableViewCell {
    
    static let cellIdentifier = CellIdentifiers.OptionSelectionTableViewCell
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(data: QuestionOption) {
        let value = data.isAnswer
        tickImageView.isHidden = !value
        optionLabel.text = data.value
        optionLabel.textColor =  (value ? UIColor.colorWithRGB(r: 44, g: 50, b: 68) : UIColor.colorWithRGB(r: 111, g: 118, b: 139))
    }
    
}
