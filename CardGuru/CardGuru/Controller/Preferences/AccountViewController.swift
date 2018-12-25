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
    @IBOutlet private weak var logoutButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackItem(with: "")
        fillOutlets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - IBActions
    
    @IBAction private func logoutPressed(_ sender: Any) {
        FbLoginService.sharedInstance.signOut()
        GoogleLoginService.sharedInstance.signOut()
        navigationController?.viewControllers.removeAll()
        NavigationControllerService.shared.presentCurrentUserUI()
    }
    
    // MARK: - Private
    
    func fillOutlets() {
        let user = UserDefaults().fetchUser()
        self.nameLabel.text = user?.name
        self.emailLabel.text = user?.email
        Effects.addShadow(for: logoutButton)
        if let url = user?.absoluteURL {
            Downloader.shared.loadImage(url) { image in
                self.accountImageView.image = image
            }
        }
    }
}
