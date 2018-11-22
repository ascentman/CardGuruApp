//
//  Animations.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class Animations {
    
    typealias animationClosure = (_ animation: CAAnimation) -> ()
    
    class func horizontalMovement(on layer: CALayer, from: CGPoint, to: CGPoint, completion: animationClosure) {
        let cardAnimation = CABasicAnimation()
        cardAnimation.fromValue = from
        cardAnimation.toValue = to
        cardAnimation.duration = 4.0
        completion(cardAnimation)
    }
    
    class func appearence(on layer: CALayer, from: CGFloat, to: CGFloat, completion: animationClosure) {
        let checkAnimation = CABasicAnimation()
        checkAnimation.fromValue = from
        checkAnimation.toValue = to
        checkAnimation.duration = 1.0
        completion(checkAnimation)
    }
    
    class func starAnimation(on layer: CALayer, completion: animationClosure) {
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 0, y: layer.bounds.height / 2))
        starPath.addLine(to: CGPoint(x: -layer.bounds.height / 2, y: -layer.bounds.width / 2))
        starPath.addLine(to: CGPoint(x: layer.bounds.width * 2, y: layer.bounds.width / 2))
        starPath.addLine(to: CGPoint(x: -layer.bounds.width * 1.5, y: 0))
        starPath.addLine(to: CGPoint(x: layer.bounds.height / 2, y: -layer.bounds.width / 2))
        starPath.close()
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 400
        animation.repeatCount = .infinity
        animation.path = starPath.cgPath
        layer.add(animation, forKey: nil)
        completion(animation)
    }
    
    class func shimmerEffect(on layer: CALayer) {
        let light = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        let dark = UIColor.black.cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -layer.bounds.size.width / 2, y: 0, width: layer.bounds.size.width * 1.5, height: layer.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.2, 0.4, 0.6]
        layer.mask = gradient
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.2, 0.4]
        animation.toValue = [1.0, 1.2, 1.4]
        animation.duration = 4.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
}
