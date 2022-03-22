//
//  EditProfileViewController.swift
//  Trans V-BOX
//
//  Created by Suraj on 4/3/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {
    
    static var storyBoardId: String = ViewIdentifiers.EditProfileViewController
    static var storyBoardName: String = Storyboard.settings
    var imageSelected = false
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editPictureButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var editNameButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.isUserInteractionEnabled = false
    }
    
    private func setUserDetails(){
        guard let user = UserSession.shared.user?.data else { return }
        nameTextField.text = user.name ?? ""
        profileImageView.setImage(url: user.userImage)
        emailTextField.text = user.email
    }
    
    @IBAction func editPictureButtonAction(_ sender: UIButton) {
        ImagePickerManager.shared.pickImage(sender:(sender.superview?.viewWithTag(0))!, controller: self) { [unowned self] (image) in
            if let image = image {
                self.imageSelected = true
                self.profileImageView.image = image
            }
        }
    }
    
    @IBAction func editNameButtonAction(_ sender: Any) {
        nameTextField.isUserInteractionEnabled = true
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        var message = ""
        if nameTextField.text!.isEmpty {
            message = StringConstants.enterName
        }
        if !message.isEmpty {
            self.showWarningAlert(title: StringConstants.appName, message: message)
            return
        }
        self.showLoading()
        var param: [String: Any] = [APIKeys.admin: "0", APIKeys.name: nameTextField.text!.trim()]
        if imageSelected {
            param[APIKeys.image] =  profileImageView.image!.jpegData(compressionQuality: 0.5)
        }
        APIManager.shared.editProfile(param: param) { [unowned self] (response, status, error) -> (Void) in
            self.stopLoading()
            if let response = response as? UserModel {
                UserSession.shared.user = response
                UserSession.saveUserSession()
                if String(describing: response.code.value) == StringConstants.successCode {
                    self.showAlert(title: StringConstants.appName, message: response.message, completion: {[unowned self] in
                        self.navigationController?.popViewController(animated: true)
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
