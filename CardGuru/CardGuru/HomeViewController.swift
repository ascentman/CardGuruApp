//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!
    
    var name: String?
    var email: String?
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        emailLabel.text = email
        logoImageView.image = try! UIImage(withContentsOfUrl: imageURL!) ?? nil // TODO: ! fix later
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let loginController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        LoginService.sharedInstance.signOut()
        present(loginController, animated: true, completion: nil)
    }
}

extension UIImage {
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}
