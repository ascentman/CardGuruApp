//
//  AnimatedStartViewController.swift
//  CardGuru
//
//  Created by user on 12/8/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class AnimatedStartViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLogo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "GoNext", sender: self)
        }
    }
    
    // MARK: - Private
    
    private func animateLogo() {
        UIView.animate(withDuration: 0.5) {
            self.logo.center.y -= 150
            self.logo.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }
    }
    
    
}
