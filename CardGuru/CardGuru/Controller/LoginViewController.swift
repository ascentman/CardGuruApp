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

    // ті ж самі проблеми з доступом - private
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GoogleLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
            self?.saveLoginDataToDb(user)
        }
    }

    // ті ж самі проблеми з доступом

    
    @IBAction func loginWithFacebook(_ sender: Any) {
        FbLoginService.sharedInstance.signIn(self, onRequestStart: {
            SVProgressHUD.show(withStatus: "Signing in")
        }) { [weak self] (user, error) in
            self?.performSegue(withIdentifier: "GoToHome", sender: user)
            self?.saveLoginDataToDb(user)
        }
    }
    
    // MARK: - Private


    // краще мати окремий обєкт для анімацій - це ж моджна просто перевикористати і це призведе до зменшення к-ті коду в проекті
    private func animateBackground(){
        if view.layer.superlayer == backGroundLayer {
            view.layer.removeFromSuperlayer()
        }
        backGroundLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width * 1.5, height: view.frame.height * 3))
        backGroundLayer.opacity = 0.2
        backGroundLayer.contents = UIImage(named: "cards")?.cgImage
        backGroundLayer.contentsGravity = kCAGravityResizeAspectFill
        
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 0, y: backGroundLayer.bounds.height / 2))
        starPath.addLine(to: CGPoint(x: -backGroundLayer.bounds.height / 2, y: -backGroundLayer.bounds.width / 2))
        starPath.addLine(to: CGPoint(x: backGroundLayer.bounds.width * 2, y: backGroundLayer.bounds.width / 2))
        starPath.addLine(to: CGPoint(x: -backGroundLayer.bounds.width * 1.5, y: 0))
        starPath.addLine(to: CGPoint(x: backGroundLayer.bounds.height / 2, y: -backGroundLayer.bounds.width / 2))
        starPath.close()
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 400
        animation.repeatCount = MAXFLOAT
        animation.path = starPath.cgPath
        backGroundLayer.add(animation, forKey: nil)
        self.view.layer.insertSublayer(backGroundLayer, at: 0)
    }

    // контролер зберігає лого? та може ж його додати в ресурси проекту - це ж лого воно не буде мінятися 100500 раз
    // нашо його взагалі на сервер пушити?
    // знову дані краще окремо опрацбовувати в класі відмінному від viewControllmer
    private func saveLoginDataToDb(_ user: User) {
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
