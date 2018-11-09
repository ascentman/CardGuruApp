//
//  LicenceViewController.swift
//  CardGuru
//
//  Created by Vova on 11/8/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class LicenceViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.title = "Licence Agreement"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func acceptedClicked(_ sender: Any) {
        presentAlert("Info", message: "Thank you, bro!", acceptTitle: "Ok", declineTitle: nil, okActionHandler: {
            self.navigationController?.popToRootViewController(animated: true)
        }, cancelActionHandler: nil)
    }
}
