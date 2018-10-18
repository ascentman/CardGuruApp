//
//  Animations.swift
//  CardGuru
//
//  Created by Vova on 10/16/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class Animations {
    
    private var starPathAnimated: CAKeyframeAnimation?
    private var cardAnimation: CABasicAnimation?
    private var checkAnimation: CABasicAnimation?
    
    func setStarPathAnimation(on layer: CALayer) -> CAKeyframeAnimation {
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
        return animation
    }
    
    func setCardAnimation(on layer: CALayer) -> CABasicAnimation {
        cardAnimation = CABasicAnimation()
        guard let cardAnimation = cardAnimation else {
            return CABasicAnimation()
        }
        cardAnimation.fromValue = CGPoint(x: UIScreen.main.bounds.maxX + 100, y: 150)
        cardAnimation.toValue = CGPoint(x: UIScreen.main.bounds.midX, y: 150)
        cardAnimation.duration = 3.0
        cardAnimation.isRemovedOnCompletion = true
        cardAnimation.repeatCount = 1//.infinity
        return cardAnimation
    }
    
    func setCheckAnimation(on layer: CALayer) -> CABasicAnimation {
        checkAnimation = CABasicAnimation()
        guard let checkAnimation = checkAnimation else {
            return CABasicAnimation()
        }
        checkAnimation.fromValue = 0
        checkAnimation.toValue = 1
        checkAnimation.duration = 2.0
        return checkAnimation
    }
}
