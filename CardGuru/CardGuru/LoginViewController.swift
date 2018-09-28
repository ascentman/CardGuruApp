//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCurrentViewController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
        
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        LoginService.sharedInstance.signIn(self) { [weak self] user, error in
            SVProgressHUD.show(withStatus: "Signing in")
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        LoginService.sharedInstance.signInFb(self) { [weak self] (user, error) in
            SVProgressHUD.show(withStatus: "Signing in")
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    // MARK: - Private methods
    
    private func presentCurrentViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        Auth.auth().addStateDidChangeListener() { _, user in
            if LoginService.sharedInstance.isLoggedIn() {
                viewController?.name = user?.displayName
                viewController?.email = user?.email
                viewController?.imageURL = user?.photoURL
                if let viewController = viewController {
                    if !viewController.isViewLoaded {
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
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
