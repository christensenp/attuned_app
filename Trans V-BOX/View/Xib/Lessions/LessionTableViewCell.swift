//
//  LessionTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 19/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class LessionTableViewCell: UITableViewCell {
    static let cellIdentifier = CellIdentifiers.LessionTableViewCell
    @IBOutlet weak var lessionNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUp(model: Lesson, colorCode: String) {
        lessionNameLabel.text = model.name?.trim()
        timeLabel.text = "\(StringConstants.time): \(Double(model.totalTime ?? 0).format()) min"
        guard let isEnabled = model.isEnabled else {return}
        playButton.setImage(UIImage(named: isEnabled ? colorCode : "Locked"), for: .normal)
        lessionNameLabel.alpha = isEnabled ? 1.0 : 0.4
        timeLabel.alpha = isEnabled ? 1.0 : 0.4
        containerView.backgroundColor = isEnabled ? UIColor.init(colorCode) : disableColor
        if isEnabled {
            playButton.tintColor = UIColor.init(colorCode)
        }
    }

    func setUp(model: Homework, colorCode: String) {
        lessionNameLabel.text = model.name
        timeLabel.text = "\(StringConstants.time): \(Double(model.totalTime ?? 0).format()) min"
        guard let isEnabled = model.isEnabled else {return}
        playButton.setImage(UIImage(named: isEnabled ? colorCode : "Locked"), for: .normal)
        containerView.backgroundColor = isEnabled ? UIColor.init(colorCode) : disableColor
        lessionNameLabel.alpha = isEnabled ? 1.0 : 0.4
        timeLabel.alpha = isEnabled ? 1.0 : 0.4
    }
    
    
}
