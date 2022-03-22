//
//  ImagePickerManager.swift
//  Trans V-BOX
//
//  Created by Mobikasa Night on 2/27/20.
//  Copyright © 2020 Trans V-BOX. All rights reserved.
//

import UIKit
import AVFoundation

class ImagePickerManager: NSObject {
    
    static let shared = ImagePickerManager()
    private weak var controller: BaseViewController!
    let imagePicker = UIImagePickerController()
    var handler: ImageClosure!
    
    func pickImage(sender: UIView, controller: BaseViewController, handler: @escaping ImageClosure) {
        self.controller = controller
        self.handler = handler
        let alert = UIAlertController(title: StringConstants.chooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: StringConstants.camera, style: .default, handler: { [unowned self] _ in
            self.checkCamera()
        }))
        alert.addAction(UIAlertAction(title: StringConstants.gallery, style: .default, handler: { [unowned self] _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: StringConstants.cancel, style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        controller.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            controller.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: StringConstants.warning, message: StringConstants.cameraPermission, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.OK, style: .default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }

    func checkCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            presentCameraSettings()
        case .restricted:
            controller.showWarningAlert(title: StringConstants.appName, message: "Restricted, device owner must approve")
        case .authorized:
            self.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    self.openCamera()
                } else {
                    print("Permission denied")
                }
            }
        default:
            print("Permission denied")
        }
    }

    func presentCameraSettings() {
        let alertController = UIAlertController(title: StringConstants.appName,
                                                message: "Camera access is denied",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                })
            }
        })
        controller.present(alertController, animated: true)
    }
    
    func openGallary(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        controller.present(imagePicker, animated: true, completion: nil)
    }
}


extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            handler(image)
        } else {
            handler(nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        handler(nil)
        picker.dismiss(animated: true, completion: nil)
    }
}
