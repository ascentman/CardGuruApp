//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import SVProgressHUD

private enum SequeName {
    static let goToHome = "GoToHome"
}

final class LoginViewController: UIViewController {
    
    private var backGroundLayer: LoginBackgroundLayer?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundLayer = LoginBackgroundLayer(inFrame: view.frame)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction private func loginWithGoogle(_ sender: Any) {
        GoogleLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            if let user = user {
                self?.saveLoginData(user)
                self?.performSegue(withIdentifier: SequeName.goToHome, sender: user)
            }
        }
    }
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        FbLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            if let user = user {
                self?.saveLoginData(user)
                self?.performSegue(withIdentifier: SequeName.goToHome, sender: user)
            }
        }
    }
    
    // MARK: - Private

    private func animateBackground(){
        if view.layer.superlayer == backGroundLayer {
            view.layer.removeFromSuperlayer()
        }
        backGroundLayer?.animateLayer(with: { _ in
            if let backgroundLayer = self.backGroundLayer {
                self.view.layer.insertSublayer(backgroundLayer, at: 0)
            }
        })
    }
    
    @objc private func resumeAnimation() {
        animateBackground()
    }

    private func saveLoginData(_ user: User) {
        UserDefaults().save(user: User(name: user.name, email: user.email, absoluteURL: user.absoluteURL))
    }
}
