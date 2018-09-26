//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import SVProgressHUD
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.current() != nil {
            print("present Home VC")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
        
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Signing in")
        LoginService.sharedInstance.signIn(self) { [weak self] user, error in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Signing in")
        LoginService.sharedInstance.signInFb(self) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HomeViewController {
            if let user = sender as? User  {
                destination.name = user.name
                destination.email = user.email
                destination.imageURL = user.imageURL
            }
        }
    }
}
