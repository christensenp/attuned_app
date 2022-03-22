//
//  GenderTableViewCell.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/3/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class GenderTableViewCell: UITableViewCell {
    
    static let cellIdentifier = CellIdentifiers.GenderTableViewCell
    @IBOutlet weak var genderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        genderButton.isSelected = false
        // Initialization code
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        buttonTapped()
    }
    
    func setGender(title:String){
        genderButton.setTitle(title, for: .normal)
    }
    
    func buttonTapped(){
        if genderButton.isSelected == true {
            genderButton.isSelected = false
            genderButton.backgroundColor = UIColor.white
        }else {
            genderButton.isSelected = true
            genderButton.backgroundColor = UIColor.gray
        }
    }
    
    
}




