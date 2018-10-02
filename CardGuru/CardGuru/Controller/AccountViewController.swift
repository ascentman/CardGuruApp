//
//  AccountViewController.swift
//  CardGuru
//
//  Created by Vova on 10/2/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    @IBAction func logoutPressed(_ sender: Any) {
        let loginController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        LoginService.sharedInstance.signOut()
        present(loginController, animated: true, completion: nil)
    }
}
