//
//  AppDelegate.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

/**
???  - func setupSession(with completion: ((Bool) -> ())) { - як робив кілька функцій так і робить - треба зробити так як я говорив - ScannerService все ще потребує роботи
??? private var uid = String() - default параметр може бути підступним в такому використанні - якшо це обовязково - то не дозволяй створити обєкт без цих даних
??? can't reproduce: - малюнки не зберегіються після перелогінювання
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseService.shared.setupFirebase()
        GoogleLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        FbLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        setupInitialViewController()
        LocalNotificationsService.shared.registerLocalNotifications(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if GoogleLoginService.sharedInstance.handleURLIn(app, open: url, options: options) {
            return true
        } else if FbLoginService.sharedInstance.handleURLIn(app, open: url, options: options) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        NavigationControllerService.shared.presentCurrentUserUI()
    }
}
