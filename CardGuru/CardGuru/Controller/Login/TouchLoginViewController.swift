//
//  TouchLoginViewController.swift
//  CardGuru
//
//  Created by Vova on 11/9/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

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
                self.presentAlert("Error", message: "Authentication failed", acceptTitle: "Ok", declineTitle: nil, okActionHandler: {
                    self.performLogging()
                }, cancelActionHandler: nil)
            }
        }
    }
}
