//
//  CheckLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let check = "check"
    
    enum AnimationKeys {
        static let opacity = "opacity"
    }
}

private enum Frame {
    case x
    case y
    case topMargin
    
    func get() -> CGFloat {
        switch self {
        case .x:
            return 30
        case .y:
            return 30
        case .topMargin:
            return 150
        }
    }
}

class CheckLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        contents = CALayer().setImage(named: Constants.check)?.cgImage
        contentsGravity = CALayerContentsGravity.resizeAspect
        frame = CGRect(x: 0, y: 0, width: Frame.x.get(), height: Frame.y.get())
        position = CGPoint(x: inFrame.midX, y: Frame.topMargin.get())
        opacity = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateLayer(from: CGFloat, to: CGFloat, with completion: ((Bool) -> ())?) {
        Animations.shared.appearence(on: self, from: from, to: to, completion: { [weak self] animation in
            animation.onComplete = completion
            animation.isRemovedOnCompletion = true
            self?.add(animation, forKey: Constants.AnimationKeys.opacity)
        })
    }
}
