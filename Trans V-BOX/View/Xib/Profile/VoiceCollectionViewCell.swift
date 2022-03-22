//
//  VoiceCollectionViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 04/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class VoiceCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = CellIdentifiers.VoiceCollectionViewCell
    
    @IBOutlet weak var widthConstant: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageViw: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(model: QuestionOption) {
        nameLabel.text = model.value ?? ""
        imageViw.setImage(url: model.optionImg, placeHolder: "C")
        imageViw.borderWidth = model.isAnswer ? 2 : 0
        nameLabel.font = UIFont(name: model.isAnswer ? Font.YuGothicBold : Font.YuGothicMedium, size: nameLabel.font.pointSize)
    }
    
}
