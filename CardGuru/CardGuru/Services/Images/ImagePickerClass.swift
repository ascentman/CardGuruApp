//
//  ImagePickerClass.swift
//  CardGuru
//
//  Created by user on 11/4/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class ImagePickerClass: NSObject {
    
    private var picker = UIImagePickerController()
    private var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    private var viewController: UIViewController?
    private var pickImageCompletion : ((UIImage) -> ())?;
    
    func pickImage(_ viewController: UIViewController, _ completion: @escaping ((UIImage) -> ())) {
        self.viewController = viewController
        pickImageCompletion = completion
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo Library", style: .default){
            UIAlertAction in
            self.openPhotoGallery()
        }
        let defaultAction = UIAlertAction(title: "Default image", style: .default){
            UIAlertAction in
            self.setDefaultImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.showsCameraControls = true
            picker.allowsEditing = true
            self.viewController?.present(picker, animated: true, completion: nil)
        } else {
            print("no camera")
        }
    }
    
    private func openPhotoGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController?.present(picker, animated: true, completion: nil)
    }
    
    private func setDefaultImage() {
        pickImageCompletion?(UIImage(named: "shop") ?? UIImage())
    }
}

extension ImagePickerClass : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK - UIImagePickerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        pickImageCompletion?(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
