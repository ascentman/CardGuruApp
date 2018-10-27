//
//  AccountViewController.swift
//  CardGuru
//
//  Created by Vova on 10/2/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class AccountViewController: UIViewController {

    @IBOutlet private weak var accountImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userEmail = UserDefaults().email,
            let userName = UserDefaults().name,
            let userLogo = UserDefaults().logo {
            self.nameLabel.text = userName
            self.emailLabel.text = userEmail
            self.accountImageView.image = UIImage(data: userLogo)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - IBActions
    
    @IBAction private func logoutPressed(_ sender: Any) {
        FbLoginService.sharedInstance.signOut()
        GoogleLoginService.sharedInstance.signOut()
        NavigationControllerService.shared.presentCurrentUserUI()
    }
}
