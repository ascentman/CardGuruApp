//
//  Animations.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class Animations {
    static let shared = Animations()
    private init() {}
    
    typealias animationClosure = (_ animation: CAAnimation) -> ()
    
    func horizontalMovement(on layer: CALayer, from: CGPoint, to: CGPoint, completion: animationClosure) {
        let cardAnimation = CABasicAnimation()
        cardAnimation.fromValue = from
        cardAnimation.toValue = to
        cardAnimation.duration = 4.0
        completion(cardAnimation)
    }
    
    func appearence(on layer: CALayer, from: CGFloat, to: CGFloat, completion: animationClosure) {
        let checkAnimation = CABasicAnimation()
        checkAnimation.fromValue = from
        checkAnimation.toValue = to
        checkAnimation.duration = 1.0
        completion(checkAnimation)
    }
    
    func starAnimation(on layer: CALayer, completion: animationClosure) {
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
}
