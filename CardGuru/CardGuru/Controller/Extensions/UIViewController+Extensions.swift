//
//  UIViewController+Extensions.swift
//  CardGuru
//
//  Created by Vova on 10/25/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Settings Alert View Controller
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.performSegue(withIdentifier: "AddNewCard", sender: nil)
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
