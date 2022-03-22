//
//  LessonCompletePopupViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 08/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class LessonCompletePopupViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.LessonCompletePopupViewController
    static var storyBoardName: String = Storyboard.lessions
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var handler: EmptyAction?
    var lessonName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = titleLabel.text!.replacingOccurrences(of: "lesson 2", with: lessonName)
        titleLabel.text = text
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reminderMelaterButtonAction(_ sender: Any) {
        self.presentAddCallNotificationContoller(name: "")
    }
    
    @IBAction func recordNowButtonAction(_ sender: Any) {
        let controller = VoiceTrackerViewController.instantiateFromStoryBoard()
        controller.isButtonHidden = false
        let root = UINavigationController(rootViewController: controller)
        root.modalPresentationStyle = .fullScreen
        self.present(root, animated: true, completion: nil)
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: { [weak self] in
            guard let self = self, let handler = self.handler else { return }
            handler()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
