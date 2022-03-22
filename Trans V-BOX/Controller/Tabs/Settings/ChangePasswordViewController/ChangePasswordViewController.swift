//
//  ChangePasswordViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 15/04/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    static var storyBoardId: String = ViewIdentifiers.ChangePasswordViewController
    static var storyBoardName: String = Storyboard.settings
    @IBOutlet weak var newPassword: CustomTextField!
    @IBOutlet weak var confirmPassword: CustomTextField!
    @IBOutlet weak var oldPasswordTextField: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = StringConstants.passwordChange
        self.navigationController?.isNavigationBarHidden = false
        self.setRightBarButtonItem(imageName: "wrong")
        // Do any additional setup after loading the view.
    }
    
    override func rightButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        var message = ""
        if oldPasswordTextField.text!.trim().isEmpty {
            message = StringConstants.oldPassword
        } else if newPassword.text!.trim().isEmpty {
            message = StringConstants.newPassword
        } else if confirmPassword.text!.trim().isEmpty {
            message = StringConstants.confirmPassword
        } else if newPassword.text!.trim() != confirmPassword.text!.trim() {
            message = StringConstants.doesntMatch
        }
        
        if !message.isEmpty {
            self.showWarningAlert(title: StringConstants.appName, message: message)
            return
        }
        self.changePassword()
    }
    
    func changePassword() {
        self.view.endEditing(true)
        self.showLoading()
        let param: [String: Any] = [APIKeys.oldPassword: oldPasswordTextField.text!, APIKeys.newPassword: newPassword.text!]
        APIManager.shared.changePassword(param: param) { [weak self] (response, status, error) -> (Void) in
            guard let self = self else {return}
            self.stopLoading()
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    self.showAlert(title: StringConstants.appName, message: response.message, completion: { [weak self] in
                        guard let self = self else { return }
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if oldPasswordTextField.isFirstResponder {
            newPassword.becomeFirstResponder()
        } else if newPassword.isFirstResponder {
            confirmPassword.becomeFirstResponder()
        } else if confirmPassword.isFirstResponder {
            self.view.endEditing(true)
            self.changePassword()
        }
        return true
    }
}
