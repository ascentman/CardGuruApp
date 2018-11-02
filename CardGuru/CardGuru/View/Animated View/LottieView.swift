//
//  LottieView.swift
//  CardGuru
//
//  Created by user on 11/2/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Lottie

class LottieView {
    
    class func setupBackgroundGradient(on view: UIView) {
        let backGroundView = LOTAnimationView(name: "backGround")
        backGroundView.frame = view.frame
        backGroundView.loopAnimation = true
        backGroundView.animationSpeed = 0.05
        backGroundView.play()
        view.addSubview(backGroundView)
        view.sendSubviewToBack(backGroundView)
    }
}
