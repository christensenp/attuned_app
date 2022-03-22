//
//  SignInViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/27/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.signInViewController
    static var storyBoardName: String = Storyboard.main
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dismissView: UIControl!
    var handler: EmptyAction!
    var successHandler: EmptyAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.rightViewMode = .never
        emailTextField.rightView = UIImageView(image:  UIImage(named: "right sign"))
        self.view.sendSubviewToBack(self.dismissView)
        let image = UIImage(named: "Group")!
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(passwordShowHideButtonAction(_ :)), for: .touchUpInside)
        self.passwordTextField.rightViewMode = .always
        self.passwordTextField.rightView = button
        emailTextField.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        textField.rightViewMode = (textField.text!.isValidEmail() ? UITextField.ViewMode.always :  UITextField.ViewMode.never)
    }
    
    func closure(dismissHandler: @escaping EmptyAction, successHandler: @escaping EmptyAction) {
        self.handler = dismissHandler
        self.successHandler = successHandler
    }
    
    @objc func passwordShowHideButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func loginButtonAction(_ sender: Any? = nil) {
        var message = ""
        if emailTextField.text!.trim().isEmpty {
            message = StringConstants.enterEmail
        } else if !emailTextField.text!.isValidEmail() {
            message = StringConstants.validEmail
        } else if passwordTextField.text!.isEmpty {
            message = StringConstants.enterPassword
        }
        if !message.isEmpty {
            self.showWarningAlert(title: StringConstants.appName, message: message)
            return
        }
        self.showLoading()
        let param = [APIKeys.email: emailTextField.text!.trim(), APIKeys.password: passwordTextField.text!]
        APIManager.shared.login(param: param) { [unowned self] (response, status, error) -> (Void) in
            self.stopLoading()
            if let response = response as? UserModel {
                if String(describing: response.code.value) == StringConstants.successCode {
                    UserSession.shared.user = response
                    UserSession.saveUserSession()
                    if let data = response.data, let isCompleted = data.isCompleted?.value, let value = Int("\(isCompleted)"), value == 1 {
                        UserDefaults.standard.set(true, forKey: UserDefaultKey.isProfileCompleted)
                    }
                    self.dismiss(animated: true, completion: { [unowned self] in
                        self.successHandler()
                    })
                } else {
                    self.showWarningAlert(title: StringConstants.appName, message: response.message)
                }
            } else {
                self.showWarningAlert(title: StringConstants.appName, message: error ?? "")
            }
        }
    }
    
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        let controller = ForgotPasswordViewController.instantiateFromStoryBoard()
        controller.closure(successHandler: { [unowned self] in
              
        })
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: { [unowned self] in
            self.handler()
        })
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            self.view.endEditing(true)
            self.loginButtonAction()
        }
        return true
    }
}
