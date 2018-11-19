//
//  TouchLoginViewController.swift
//  CardGuru
//
//  Created by Vova on 11/9/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let alertTitle = NSLocalizedString("Error", comment: "")
    static let alertMessage = NSLocalizedString("Authentication failed", comment: "")
    static let acceptTitle = NSLocalizedString("Ok", comment: "")
}

final class TouchLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performLogging()
    }
    
    private func performLogging() {
        Authenticator.shared.loggingWithTouchId { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "GoToMain", sender: nil)
                }
            } else {
                self.presentAlert(Constants.alertTitle, message: Constants.alertMessage, acceptTitle: Constants.acceptTitle, declineTitle: nil, okActionHandler: {
                    self.performLogging()
                }, cancelActionHandler: nil)
            }
        }
    }
}
