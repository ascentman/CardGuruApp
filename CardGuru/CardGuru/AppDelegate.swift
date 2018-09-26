//
//  AppDelegate.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
}
