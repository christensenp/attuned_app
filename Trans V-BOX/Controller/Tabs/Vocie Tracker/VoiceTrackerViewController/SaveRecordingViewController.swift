//
//  SaveRecordingViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 19/05/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class SaveRecordingViewController: BaseViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var recordingNameView: UIView!
    static var storyBoardId: String = ViewIdentifiers.SaveRecordingViewController
    static var storyBoardName: String = Storyboard.voiceTracker
    @IBOutlet weak var recordingNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIControl!
    @IBOutlet weak var cancelButton: UIControl!
    var recodingName: String = ""
    @IBOutlet weak var popUpView: UIView!
    var handler: SLAlertCompletion!
    var isUpdate: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingNameTextField.text = recodingName
        messageLabel.text = isUpdate ? StringConstants.updateRecording : StringConstants.saveRecording
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.colorWithRGB(r: 242, g: 209, b: 132).cgColor,
                           UIColor.colorWithRGB(r: 247, g: 197, b: 171).cgColor,
                           UIColor.colorWithRGB(r: 245, g: 188, b: 200).cgColor,
                           UIColor.colorWithRGB(r: 167, g: 195, b: 227).cgColor,
                           UIColor.colorWithRGB(r: 201, g: 237, b: 227).cgColor]
        gradient.frame = popUpView.bounds
        popUpView.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        if recordingNameTextField.text!.trim().isEmpty {
            recordingNameView.borderColor = .red
            recordingNameView.shake()
        } else {
            handler(recordingNameTextField.text!.trim(), self)
        }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
