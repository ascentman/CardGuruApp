//
//  CAAnimation+Block.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class CAAnimationClassDelegate: NSObject, CAAnimationDelegate {
    
    // MARK: - CAAnimation+Block
    
    var didStartAnimation: (() -> ())?
    var didEndAnimation: ((Bool) -> ())?
    
    func animationDidStart(_ theAnimation: CAAnimation) {
        didStartAnimation?()
        didStartAnimation = nil
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didEndAnimation?(flag)
        didEndAnimation = nil
    }
}

extension CAAnimation {
    
    // MARK: - CAAnimation+Block
    
    var animationDidStart:(() -> ())? {
        set {
            if let callbackDelegate = delegate as? CAAnimationClassDelegate {
                callbackDelegate.didStartAnimation = newValue
            } else {
                let callbackDelegate = CAAnimationClassDelegate()
                callbackDelegate.didStartAnimation = newValue
                self.delegate = callbackDelegate
            }
        }
        get {
            if let animationDelegate = delegate as? CAAnimationClassDelegate {
                return animationDelegate.didStartAnimation
            }
            return nil
        }
    }
    
    var onComplete: ((Bool) -> ())? {
        set {
            self.isRemovedOnCompletion = false
            if let callbackDelegate = delegate as? CAAnimationClassDelegate {
                callbackDelegate.didEndAnimation = newValue
            } else {
                let callbackDelegate = CAAnimationClassDelegate()
                callbackDelegate.didEndAnimation = newValue
                self.delegate = callbackDelegate
            }
        }
        get {
            if let animationDelegate = delegate as? CAAnimationClassDelegate {
                return animationDelegate.didEndAnimation
            }
            return nil
        }
    }
}
