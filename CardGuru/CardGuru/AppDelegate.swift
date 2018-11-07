//
//  AppDelegate.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

/*
--------------------------------------------------------------------------------------------------------------------------------------------

- UserDefaults використовується для зберегігання обєкту користувача (його деталей) - краще тоді серіалізувати модель і зберегти її на диск і потім зчитати - використиай Codable протокол
 
 --------------------------------------------------------------------------------------------------------------------------------------------
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var navigationService: NavigationControllerService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseService.shared.setupFirebase()
        GoogleLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        FbLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        setupInitialViewController()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if GoogleLoginService.sharedInstance.handleURLIn(app, open: url, options: options) {
//            return true
//        }
//        else if FbLoginService.sharedInstance.handleURLIn(app, open: url, options: options) {
//            return true
//        }
//        else {
//            return false
//        }
        GoogleLoginService.sharedInstance.handleURLIn(app, open: url, options: options)
        FbLoginService.sharedInstance.handleURLIn(app, open: url, options: options)
        return true
    }
    
    // MARK: Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        NavigationControllerService.shared.presentCurrentUserUI()
    }
}
