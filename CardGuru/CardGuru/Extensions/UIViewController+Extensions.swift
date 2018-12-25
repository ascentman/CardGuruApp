//
//  UIViewController+Extensions.swift
//  CardGuru
//
//  Created by Vova on 10/25/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(_ title: String,
                      message : String,
                      acceptTitle: String,
                      declineTitle: String?,
                      okActionHandler:  (()->())? = nil,
                      cancelActionHandler:  (()->())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: acceptTitle, style: .default) { _ in
            okActionHandler?()
        }
        alertController.addAction(settingsAction)
        
        if let declineTitle = declineTitle {
            let cancelAction = UIAlertAction(title: declineTitle, style: .cancel, handler: { _ in
                cancelActionHandler?()
            })
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true)
    }
    
    func setupBackItemToRoot(with title: String) {
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backToRoot))
        newBackButton.image = UIImage(named: "back")?.maskWithColor(color: UIColor.orange)
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func backToRoot() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupBackItem(with title: String) {
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        newBackButton.image = UIImage(named: "back")?.maskWithColor(color: UIColor.orange)
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func back() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    func presentAlertWithTextField(_ title: String,
                      message : String,
                      acceptTitle: String,
                      declineTitle: String?,
                      inputPlaceholder: String? = nil,
                      okActionHandler:  ((_ text: String?) -> (Void))? = nil,
                      cancelActionHandler:  (()->())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = inputPlaceholder
        }
        
        let okAction = UIAlertAction(title: acceptTitle, style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                okActionHandler?(nil)
                return
            }
            okActionHandler?(textField.text)
        }
        alertController.addAction(okAction)
        
        if let declineTitle = declineTitle {
            let cancelAction = UIAlertAction(title: declineTitle, style: .cancel, handler: { _ in
                cancelActionHandler?()
            })
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true)
    }
}
