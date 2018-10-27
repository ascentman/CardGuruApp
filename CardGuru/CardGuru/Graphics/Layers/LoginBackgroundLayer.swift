//
//  LoginBackgroundLayer.swift
//  CardGuru
//
//  Created by user on 10/28/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let card = "card"
    
    enum AnimationKeys {
        static let position = "position"
    }
}


class LoginBackgroundLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        contents = UIImage(named: "cards")?.cgImage
        contentsGravity = CALayerContentsGravity.resizeAspectFill
        opacity = 0.25
        frame = CGRect(origin: CGPoint.zero, size: CGSize(width: inFrame.width * 1.5, height:inFrame.height * 3))
        position = CGPoint(x: inFrame.midX, y: inFrame.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLayer(with completion: ((Bool) -> ())?) {
        Animations.shared.starAnimation(on: self, completion: { [weak self] (animation) in
            animation.isRemovedOnCompletion = true
            animation.onComplete = completion
            self?.add(animation, forKey: Constants.AnimationKeys.position)
        })
    }
}
