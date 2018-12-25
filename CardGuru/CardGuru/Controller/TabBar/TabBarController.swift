//
//  TabBarController.swift
//  CardGuru
//
//  Created by Vova on 11/29/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        if fromView != toView {
            if let array = viewControllers,
                let selected = selectedViewController,
                let result = array.index(where: {$0 === selected}) {
                switch result {
                case 0:
                    UIView.transition(from: fromView, to: toView, duration: 0.6, options: [.transitionFlipFromRight, .curveEaseInOut], completion: nil)
                case 1:
                    UIView.transition(from: fromView, to: toView, duration: 0.6, options: [.transitionFlipFromLeft, .curveEaseInOut], completion: nil)
                default:
                    break
                }
            }
        }
        return true
    }
}
