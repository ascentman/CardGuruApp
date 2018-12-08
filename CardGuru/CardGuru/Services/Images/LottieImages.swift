//
//  LottieImages.swift
//  CardGuru
//
//  Created by Vova on 12/6/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Lottie

final class LottieImages {
    
    class func setupCardsAnimation(on view: UIView) {
        let lottieView = LOTAnimationView(name: "LottieCards")
        lottieView.loopAnimation = true
        view.addSubview(lottieView)
        lottieView.play()
    }
}
