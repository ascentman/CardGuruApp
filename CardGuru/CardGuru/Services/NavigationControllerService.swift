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
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            let homeViewController = UIStoryboard(name: Constants.StoryboardName.main, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = homeViewController
        } else {
            let loginViewController = UIStoryboard(name: Constants.StoryboardName.login, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = loginViewController
        }
        self.window?.makeKeyAndVisible()
    }
}