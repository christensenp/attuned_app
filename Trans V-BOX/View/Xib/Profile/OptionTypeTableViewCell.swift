//
//  OptionTypeTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 3/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class OptionTypeTableViewCell: UITableViewCell {
    
    static let cellIdentifier = CellIdentifiers.OptionTypeTableViewCell
    @IBOutlet weak var textField: UITextField!
    var handler: StringCompletion!
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUP(text: String, handler: @escaping StringCompletion) {
        textField.text = text
        self.handler = handler
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        handler(textField.text!)
    }
    
}

extension OptionTypeTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: .letters) != nil || string == " " || string == "" {
            return true
        } else {
            return false
        }
    }
}
