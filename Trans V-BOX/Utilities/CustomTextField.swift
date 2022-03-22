//
//  CustomTextField.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 3/2/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtColor = UIColor.colorWithRGB(r: 83, g: 93, b: 126)
        self.placeHolderColor = UIColor.colorWithRGB(r: 111, g: 118, b: 139)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//extension UITextField{
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
//        }
//    }
//
//    @IBInspectable var txtColor: UIColor? {
//        get {
//            return self.textColor
//        }
//        set {
//            self.textColor = newValue!
//        }
//    }
//}
