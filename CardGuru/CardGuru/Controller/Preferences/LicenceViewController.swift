//
//  LicenceViewController.swift
//  CardGuru
//
//  Created by Vova on 11/8/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let licenceTitle = NSLocalizedString("Licence Agreement", comment: "")
    static let alertTitle = NSLocalizedString("Info", comment: "")
    static let alertMessage = NSLocalizedString("License Agreement has been accepted!", comment: "")
    static let acceptTitle = NSLocalizedString("Ok", comment: "")
}

final class LicenceViewController: UIViewController {

    @IBOutlet weak var acceptLicenceButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.title = Constants.licenceTitle
//        if UserDefaults().isLicenceAccepted {
//            acceptLicenceButton.isHidden = true
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 0, alpha: 1.0)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func acceptedClicked(_ sender: Any) {
        presentAlert(Constants.alertTitle, message: Constants.alertMessage, acceptTitle: Constants.acceptTitle, declineTitle: nil, okActionHandler: {
            self.navigationController?.popToRootViewController(animated: true)
            UserDefaults().saveLicenceStatus(current: true)
        }, cancelActionHandler: nil)
    }
}
