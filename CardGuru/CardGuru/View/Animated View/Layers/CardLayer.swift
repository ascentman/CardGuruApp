//
//  CardLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let card = "card"
    
    enum AnimationKeys {
        static let position = "position"
    }
}

private enum Frame {
    case x
    case y
    case startYPosition
    
    func get() -> CGFloat {
        switch self {
        case .x:
            return 50
        case .y:
            return 50
        case .startYPosition:
            return UIScreen.main.bounds.maxY + 100
        }
    }
}

class CardLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        contents = CALayer().setImage(named: Constants.card)?.cgImage
        contentsGravity = CALayerContentsGravity.resizeAspect
        frame = CGRect(x: 0, y: 0, width: Frame.x.get(), height: Frame.y.get())
        position = CGPoint(x: inFrame.midX, y: Frame.startYPosition.get())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLayer(from: CGPoint, to: CGPoint, with completion: ((Bool) -> ())?) {
        Animations.shared.horizontalMovement(on: self, from: from, to: to, completion: { [weak self] animation in
            animation.isRemovedOnCompletion = true
            animation.onComplete = completion
            self?.add(animation, forKey: Constants.AnimationKeys.position)
        })
    }
}
