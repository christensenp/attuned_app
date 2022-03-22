//
//  DisclaimerViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/25/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import SafariServices

class DisclaimerViewController: BaseViewController {

    static var storyBoardId: String = ViewIdentifiers.disclaimerViewController
    static var storyBoardName: String = Storyboard.main
    @IBOutlet weak var textView: UITextView!
    var handler: EmptyAction!
    var isFromSetting: Bool = false
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var doNotShowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        if isFromSetting {
            self.setRightBarButtonItem(imageName: "wrong")
            agreeButton.isHidden = true
            doNotShowButton.isHidden = true
        }
        textView.delegate = self
        textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.colorWithRGB(r: 83, g: 93, b: 126),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        // Do any additional setup after loading the view.
    }
    
    override func rightButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func agreeButtonAction(_ sender: Any) {
        if doNotShowButton.isSelected {
            let onboardingViewController = OnboardingViewController.instantiateFromStoryBoard()
            push(onboardingViewController)
        } else {
            self.showWarningAlert(title: StringConstants.appName, message: StringConstants.agreeButtonMessage)
        }
    }
    
    @IBAction func doNotShowButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UserDefaults.standard.set(sender.isSelected, forKey: UserDefaultKey.doNotShow)
    }
}

extension DisclaimerViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = SFSafariViewController(url: URL)
        present(vc, animated: true, completion: nil)
        return false
    }
}
