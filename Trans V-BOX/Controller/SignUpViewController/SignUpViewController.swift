//
//  SignUpViewController.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/27/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SafariServices

class SignUpViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.signUpViewController
    static var storyBoardName: String = Storyboard.main
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var yourNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var termsLabel: TTTAttributedLabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var dismissView: UIControl!
    
    var handler: EmptyAction!
    var successHandler: EmptyAction!
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.dismissView)
        emailTextField.rightViewMode = .never
        emailTextField.rightView = UIImageView(image:  UIImage(named: "right sign"))
        let image = UIImage(named: "Group")!
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(passwordShowHideButtonAction(_ :)), for: .touchUpInside)
        self.passwordTextField.rightViewMode = .always
        self.passwordTextField.rightView = button
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
        emailTextField.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
        
        termsLabel.linkAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.init("#6F768B"),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        let range = (termsLabel.text! as! NSString).range(of: "Terms of Use")
        termsLabel.addLink(to: URL(string: "https://www.google.com/")!, with: range)
        termsLabel.enabledTextCheckingTypes = NSTextCheckingAllTypes
        termsLabel.delegate = self
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
    
    @IBAction func signUpButtonAction(_ sender: Any? = nil) {
        self.view.endEditing(true)
        var message = ""
        if yourNameTextField.text!.isEmpty {
            message = StringConstants.enterName
        } else if emailTextField.text!.trim().isEmpty {
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
        var param: [String: Any] = [APIKeys.admin: "0", APIKeys.name: yourNameTextField.text!.trim(), APIKeys.email: emailTextField.text!.trim(), APIKeys.password: passwordTextField.text!]
        if imageSelected {
            param[APIKeys.image] =  profileImageView.image!.jpegData(compressionQuality: 0.5)
        }
        APIManager.shared.signUp(param: param) { [unowned self] (response, status, error) -> (Void) in
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
    
    @IBAction func signInButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: { [unowned self] in
            self.handler()
        })
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        ImagePickerManager.shared.pickImage(sender: sender.view!, controller: self) { [unowned self] (image) in
            if let image = image {
                self.imageSelected = true
                self.profileImageView.image = image
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if yourNameTextField.isFirstResponder {
            emailTextField.becomeFirstResponder()
        } else if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            self.view.endEditing(true)
            self.signUpButtonAction()
        }
        return true
    }
}


extension SignUpViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let url = url {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}
