//
//  LessionsUserTableViewCell.swift
//  Trans V-BOX
//
//  Created by Mobikasa  on 19/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import SDWebImage

class LessionsUserTableViewCell: UITableViewCell {
    
    static let cellIdentifier = CellIdentifiers.LessionsUserTableViewCell
    let tapGesture = UITapGestureRecognizer()
    var imageTapped:EmptyAction? = nil
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGesture.addTarget(self, action:#selector(tappedImage))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUP() {
        guard let user = UserSession.shared.user?.data else { return }
        userNameLabel.text = user.name ?? ""
        profileImageView.setImage(url: user.userImage)
    }
    
    @objc func tappedImage(){
        if let imageTapped = imageTapped{
            imageTapped()
        }
    }
}
