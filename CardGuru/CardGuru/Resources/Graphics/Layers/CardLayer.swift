//
//  CardLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let imageName = "card"
    
    enum AnimationKeys {
        static let position = "position"
    }
}

final class CardLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        contents = UIImage(named: Constants.imageName)?.maskWithColor(color: UIColor(red: 249/255, green: 169/255, blue: 0, alpha: 1.0)).cgImage
        contentsGravity = CALayerContentsGravity.resizeAspect
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        position = CGPoint(x: inFrame.midX, y: UIScreen.main.bounds.maxY + 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLayer(from: CGPoint, to: CGPoint, with completion: ((Bool) -> ())?) {
        Animations.horizontalMovement(on: self, from: from, to: to, completion: { [weak self] animation in
            animation.isRemovedOnCompletion = true
            animation.onComplete = completion
            self?.add(animation, forKey: Constants.AnimationKeys.position)
        })
    }
}
