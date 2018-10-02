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

class LoginViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateBackground(imgView: backgroundImageView)
    }
    
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
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        LoginService.sharedInstance.signInFb(self) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
        }
    }
    
    // MARK: - Private methods
    
    private func presentCurrentViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
//        Auth.auth().addStateDidChangeListener() { _, user in
//            if LoginService.sharedInstance.isLoggedIn() {
//                self.present(viewController, animated: true, completion: nil)
//            }
//        }
    }
    
    private func animateBackground(imgView: UIImageView){
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 200, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.path = circlePath.cgPath
        imgView.layer.add(animation, forKey: nil)
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
