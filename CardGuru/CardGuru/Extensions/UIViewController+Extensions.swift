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
}
