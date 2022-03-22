//
//  ForgotPasswordViewController.swift
//  Trans V-BOX
//
//  Created by Gourav on 23/03/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.ForgotPasswordViewController
    static var storyBoardName: String = Storyboard.main
    @IBOutlet weak var emailTextField: CustomTextField!
    var successHandler: EmptyAction!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func closure(successHandler: @escaping EmptyAction) {
        self.successHandler = successHandler
    }
    
    @IBAction func resetPasswordButtonAction(_ sender: Any? = nil) {
        self.view.endEditing(true)
        var message = ""
        if emailTextField.text!.trim().isEmpty {
            message = StringConstants.enterEmail
        }  else if !emailTextField.text!.isValidEmail() {
            message = StringConstants.validEmail
        }
        if !message.isEmpty {
            self.showWarningAlert(title: StringConstants.appName, message: message)
            return
        }
        
        self.showLoading()
        let param: [String: Any] = [APIKeys.email: emailTextField.text!.trim()]
        APIManager.shared.forgortPassword(param: param) { (response, status, error) -> (Void) in
            self.stopLoading()
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    self.showAlert(title: StringConstants.appName, message: response.message, completion: {[unowned self] in
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
    
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissViewControlAction(_ sender: Any) {
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

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resetPasswordButtonAction()
        return true
    }
}
