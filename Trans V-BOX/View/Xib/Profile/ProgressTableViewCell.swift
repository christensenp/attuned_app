//
//  ProgressTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 3/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    
    static let cellIdentifier = CellIdentifiers.ProgressTableViewCell
    @IBOutlet weak var veryMasculineLabel: UILabel!
    @IBOutlet weak var genderNutralLabel: UILabel!
    @IBOutlet weak var veryFeminiceLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var silderLeftIndicatorView: UIView!
    @IBOutlet weak var silderCenterIndicatorView: UIView!
    @IBOutlet weak var silderRightIndicatorView: UIView!
    var minimumValue: Float = 0
    var maximumValue: Float = 1.0
    var progressClosure: ProgressClosure!
    override func awakeFromNib() {
        super.awakeFromNib()
        silderCenterIndicatorView.backgroundColor = UIColor.colorWithRGB(r: 227, g: 227, b: 227)
        silderRightIndicatorView.backgroundColor = UIColor.colorWithRGB(r: 227, g: 227, b: 227)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func silderValueChanged(_ sender: UISlider) {
        self.setSlider()
        progressClosure(sender.value)
    }
    
    func setUP(model: Question?, progressClosure: @escaping ProgressClosure) {
        self.progressClosure = progressClosure
        guard let model = model else {return}
        if let value = model.minimumValue?.value,  let minimumValue = Float("\(value)") {
            self.minimumValue = minimumValue
            slider.minimumValue = self.minimumValue
        }
        if let value = model.maximumValue?.value,  let maximumValue = Float("\(value)") {
            self.maximumValue = maximumValue
            slider.maximumValue = self.maximumValue
        }
        if let value = model.midValue?.value,  let midValue = Float("\(value)") {
            slider.value = midValue
        }
        headerLabel.text = model.question ?? ""
        let isHidden = (headerLabel.text! == StringConstants.Currentlymyvoiceis)
        genderNutralLabel.isHidden = isHidden
        silderCenterIndicatorView.isHidden = isHidden
        self.setSlider()
    }
    
    func setSlider() {
        silderCenterIndicatorView.backgroundColor =  (slider.value >= (maximumValue/2) ?  UIColor.colorWithRGB(r: 111, g: 118, b: 139) : UIColor.colorWithRGB(r: 227, g: 227, b: 227))
        silderRightIndicatorView.backgroundColor =  (slider.value >= maximumValue ?  UIColor.colorWithRGB(r: 111, g: 118, b: 139) : UIColor.colorWithRGB(r: 227, g: 227, b: 227))
    }
    
}
