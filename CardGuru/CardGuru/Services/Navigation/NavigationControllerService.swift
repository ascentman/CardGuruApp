//
//  NavigationControllerService.swift
//  CardGuru
//
//  Created by Vova on 10/2/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class NavigationControllerService {
    
    static let shared = NavigationControllerService()
    private init() {}
    private weak var window: UIWindow? {
        get {
            return UIApplication.shared.delegate?.window ?? nil
        }
    }
    
    func presentCurrentUserUI() {
        if UserDefaults().isLoggedIn {
            if UserDefaults().isTouchIDEnabled {
                let touchViewController = UIStoryboard(name: StoryboardName.touch, bundle: nil).instantiateInitialViewController()
                self.window?.rootViewController = touchViewController
            } else {
                let startViewController = UIStoryboard(name: StoryboardName.start, bundle: nil).instantiateInitialViewController()
                self.window?.rootViewController = startViewController
            }
        } else {
            let loginViewController = UIStoryboard(name: StoryboardName.login, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = loginViewController
        }
        self.window?.makeKeyAndVisible()
    }
    
    func presentAddViewController() {
        if UserDefaults().isLoggedIn {
            let addViewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: "AddCardViewController")
            let tabBarViewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
            let navigationController = tabBarViewController?.viewControllers?.first as? UINavigationController
            navigationController?.viewControllers.append(addViewController)
            self.window?.rootViewController = tabBarViewController
        } else {
            let loginViewController = UIStoryboard(name: StoryboardName.login, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = loginViewController
        }
        self.window?.makeKeyAndVisible()
    }
    
    func presentDetailsViewController(with card: LastCard) {
        if UserDefaults().isLoggedIn {
            let detailsViewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: "DetailsVC") as? DetailedViewController
            guard let data = card.imageData else {
                return
            }
            detailsViewController?.setDetailedCard(uid: "", name:card.name, barcode: card.barcode, image: UIImage(data: data) ?? UIImage(), absoluteURL: "", notes: nil)
            let tabBarViewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
            let navigationController = tabBarViewController?.viewControllers?.first as? UINavigationController
            navigationController?.viewControllers.append(detailsViewController!)
            self.window?.rootViewController = tabBarViewController
        } else {
            let loginViewController = UIStoryboard(name: StoryboardName.login, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = loginViewController
        }
        self.window?.makeKeyAndVisible()
    }
}
