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
        newBackButton.image = UIImage(named: "back")?.maskWithColor(color: UIColor(red: 249/255, green: 169/255, blue: 0, alpha: 1.0))
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func backToRoot() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupBackItem(with title: String) {
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        newBackButton.image = UIImage(named: "back")?.maskWithColor(color: UIColor(red: 249/255, green: 169/255, blue: 0, alpha: 1.0))
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func back() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
}
