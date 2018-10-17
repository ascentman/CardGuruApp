//
//  AccountViewController.swift
//  CardGuru
//
//  Created by Vova on 10/2/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase // оце скрізь - має бути твій сервіс який знає про firebase - шо буде якшо я скажу змінити baas з Firebase на інше - тоді тобі тупо весь код мінти і перебирати - якшо ж буде в сервісі то лише 1 файл і все - переробити

final class AccountViewController: UIViewController {

    @IBOutlet private weak var accountImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
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

    // MARK: - IBActions
    
    @IBAction private func logoutPressed(_ sender: Any) {
        FbLoginService.sharedInstance.signOut()
        GoogleLoginService.sharedInstance.signOut()
        NavigationControllerService.shared.presentCurrentUserUI()
    }
}
