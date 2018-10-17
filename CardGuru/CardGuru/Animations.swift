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
        animation.repeatCount = MAXFLOAT
        animation.path = starPath.cgPath
        layer.add(animation, forKey: nil)
        return animation
    }
}
