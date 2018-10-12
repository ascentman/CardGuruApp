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
            let homeViewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = homeViewController
        } else {
            let loginViewController = UIStoryboard(name: StoryboardName.login, bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = loginViewController
        }
        self.window?.makeKeyAndVisible()
    }
}

extension UserDefaults {
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
}
