//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import SVProgressHUD

private enum Constants {
    static let goToHome = "GoToHome"
    static let statusTitle = NSLocalizedString("Signing in", comment: "")
}

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var backgroundCardsImageView: UIImageView!
    @IBOutlet weak var gogleLoginButton: UIButton!
    private var backGroundLayer: LoginBackgroundLayer?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLogo()
        animateBackground()
        addShadowOnUI()
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
            SVProgressHUD.show(withStatus: Constants.statusTitle)
        }) { [weak self] (user, error) in
            if let user = user {
                self?.saveLoginData(user)
                self?.performSegue(withIdentifier: Constants.goToHome, sender: user)
            } else {
                SVProgressHUD.dismiss()
                UserDefaults().saveLoggedState(current: false)
            }
        }
    }
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        FbLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: Constants.statusTitle)
        }) { [weak self] (user, error) in
            if let user = user {
                self?.saveLoginData(user)
                self?.performSegue(withIdentifier: Constants.goToHome, sender: user)
            } else {
                SVProgressHUD.dismiss()
                UserDefaults().saveLoggedState(current: false)
            }
        }
    }
    
    // MARK: - Private

    private func animateBackground(){
        let magnitude = 10.0
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        backgroundCardsImageView.addMotionEffect(group)
//        if view.layer.superlayer == backGroundLayer {
//            view.layer.removeFromSuperlayer()
//        }
//        backGroundLayer?.animateLayer(with: { _ in
//            if let backgroundLayer = self.backGroundLayer {
//                self.view.layer.insertSublayer(backgroundLayer, at: 0)
//            }
//        })
    }
    
    private func animateLogo() {
        UIView.animate(withDuration: 0.5) {
            self.logoImageView.center.y -= 150
            self.logoImageView.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
        }
    }
    
    @objc private func resumeAnimation() {
        animateBackground()
    }

    private func saveLoginData(_ user: User) {
        UserDefaults().save(user: User(name: user.name, email: user.email, absoluteURL: user.absoluteURL))
    }
    
    private func addShadowOnUI() {
        Effects.addShadow(for: fbLoginButton)
        Effects.addShadow(for: gogleLoginButton)
    }
}
