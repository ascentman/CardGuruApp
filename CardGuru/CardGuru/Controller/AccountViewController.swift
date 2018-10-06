//
//  AccountViewController.swift
//  CardGuru
//
//  Created by Vova on 10/2/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase // оце скрізь - має бути твій сервіс який знає про firebase - шо буде якшо я скажу змінити baas з Firebase на інше - тоді тобі тупо весь код мінти і перебирати - якшо ж буде в сервісі то лише 1 файл і все - переробити

class AccountViewController: UIViewController { // final

    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // те ж саме про контроль даних як і в інщих контролерах
        DatabaseService.shared.settingsRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as? [String: Any]
                self.nameLabel.text = data?["name"] as? String
                self.emailLabel.text = data?["email"] as? String
            }
        }
        DatabaseService.shared.logoRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    self.accountImageView.image = UIImage(data: data)
                }
            }
        }
    }

    //mark
    @IBAction func logoutPressed(_ sender: Any) { //private
        FbLoginService.sharedInstance.signOut()
        GoogleLoginService.sharedInstance.signOut()
        NavigationControllerService.shared.presentCurrentUserUI()
    }
}
