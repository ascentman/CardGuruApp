//
//  UIImageView+Extensions.swift
//  CardGuru
//
//  Created by Vova on 12/6/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension UIImageView {
    
    var imageWithFade: UIImage? {
        get{
            return self.image
        }
        set{
            UIView.transition(with: self,
                              duration: 0.4, options: .transitionCrossDissolve, animations: {
                                self.image = newValue
            }, completion: nil)
        }
    }
}
