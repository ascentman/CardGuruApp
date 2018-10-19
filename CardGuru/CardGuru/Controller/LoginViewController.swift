//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase // оце скрізь - має бути твій сервіс який знає про firebase - шо буде якшо я скажу змінити baas з Firebase на інше - тоді тобі тупо весь код мінти і перебирати - якшо ж буде в сервісі то лише 1 файл і все - переробити
import SVProgressHUD

final class LoginViewController: UIViewController {
    
    private var backGroundLayer = CALayer()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    @IBAction private func loginWithGoogle(_ sender: Any) {
        GoogleLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
            self?.saveLoginData(user)
        }
    }
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        FbLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
            self?.saveLoginData(user)
        }
    }
    
    // MARK: - Private

    private func animateBackground(){
        if view.layer.superlayer == backGroundLayer {
            view.layer.removeFromSuperlayer()
        }
        backGroundLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width * 1.5, height: view.frame.height * 3))
        backGroundLayer.opacity = 0.2
        backGroundLayer.contents = UIImage(named: "cards")?.cgImage
        backGroundLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        
        let animation = Animations()
        backGroundLayer.add(animation.setStarPathAnimation(on: backGroundLayer), forKey: nil)
        self.view.layer.insertSublayer(backGroundLayer, at: 0)
    }

    private func saveLoginData(_ user: User) {
        guard let imageURL = user.imageURL else { return }
        
        let logoImage = try? Data(contentsOf: imageURL)
        if let logoImage = logoImage {
             UserDefaults().setLogo(name: logoImage)
        }
        UserDefaults().setName(name: user.name)
        UserDefaults().setEmail(name: user.email)
    }
}
