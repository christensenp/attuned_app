//
//  SettingsTableViewCell.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let cellIdentifier = CellIdentifiers.SettingsTableViewCell
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var seperatorView: UIView!
    var handler: CompletionWithStatus?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        if let handler = self.handler {
            handler(sender.isOn)
        }
    }
    
    func setCellData(data:Settings, handler: @escaping CompletionWithStatus){
        self.handler = handler
        iconImageView.image = data.iconImage
        label.text = data.title
        toggleSwitch.isHidden = data.isSwitchHidden
        arrowImage.isHidden = data.isArrowImageHidden
        toggleSwitch.isOn = data.toggleValue
    }
    
}
