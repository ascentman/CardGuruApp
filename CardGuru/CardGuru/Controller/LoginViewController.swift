//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

final class LoginViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GoogleLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        FbLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    // MARK: - Private
    
    private func animateBackground(){
        
        let backGroundLayer = CALayer()
        backGroundLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width * 2, height: view.frame.height * 4))
        backGroundLayer.opacity = 0.2
        backGroundLayer.contents = UIImage(named: "cards")?.cgImage
        backGroundLayer.contentsGravity = kCAGravityResizeAspectFill
        
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 0, y: 1800))
        starPath.addLine(to: CGPoint(x: -1200, y: -900))
        starPath.addLine(to: CGPoint(x: 2200, y: 500))
        starPath.addLine(to: CGPoint(x: -1800, y: 0))
        starPath.addLine(to: CGPoint(x: 2000, y: -800))
        starPath.close()
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 500
        animation.repeatCount = MAXFLOAT
        animation.path = starPath.cgPath
        backGroundLayer.add(animation, forKey: nil)
        self.view.layer.insertSublayer(backGroundLayer, at: 0)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let user = sender as? User {
            guard let imageURL = user.imageURL else { return }
            let logoImage = try? Data(contentsOf: imageURL)
            if let logoImage = logoImage {
                 DatabaseService.shared.logoRef.putData(logoImage)
            }
            let parameters: [String : Any] = [ "name" : user.name,
                                               "email" : user.email]
            DatabaseService.shared.settingsRef.setValue(parameters)
        }
    }
}
