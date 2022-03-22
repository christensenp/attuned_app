//
//  AccessCodeViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/25/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class AccessCodeViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.accessCodeViewController
    static var storyBoardName: String = Storyboard.main
    @IBOutlet weak var accessCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessCodeTextField.autocapitalizationType = .allCharacters
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonAction(_ sender: Any? = nil) {
        self.view.endEditing(true)
        if accessCodeTextField.text!.trim().isEmpty {
            self.showWarningAlert(title: StringConstants.appName, message: StringConstants.enterAccess)
            return
        }
        self.showLoading()
        let param = [APIKeys.accessCode: accessCodeTextField.text!]
        APIManager.shared.accessCode(param: param) { [unowned self] (response, status, error) -> (Void) in
            self.stopLoading()
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    let controller = DisclaimerViewController.instantiateFromStoryBoard()
                    self.push(controller)
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
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


extension AccessCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.doneButtonAction()
        return true
    }
    
}
