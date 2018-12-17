//
//  UIView+Extensions.swift
//  CardGuru
//
//  Created by Vova on 12/17/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension UIView {
    
    func slide(x: CGFloat, on view: UIView, duration: Double) {
        let yPosition = view.frame.origin.y
        let height = view.frame.height
        let width = view.frame.width
        UIView.animate(withDuration: duration, animations: {
            self.frame = CGRect(x: x, y: yPosition, width: width, height: height)
        })
    }
    
    func slide(y: CGFloat, on view: UIView, duration: Double) {
        let xPosition = view.frame.origin.x
        let height = view.frame.height
        let width = view.frame.width
        UIView.animate(withDuration: duration, animations: {
            self.frame = CGRect(x: xPosition, y: y, width: width, height: height)
        })
    }
}
