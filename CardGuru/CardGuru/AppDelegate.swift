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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseService.shared.setupFirebase()
        GoogleLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        FbLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        setupInitialViewController()
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
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case "work.CardGuru.openSearch":
            setupSearchViewController()
        case "work.CardGuru.addCard":
            setupAddCardViewController()
        case "work.CardGuru.openLast":
            setupOpenLastViewController()
        default:
            break
        }
    }
    
    // MARK: Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        NavigationControllerService.shared.presentCurrentUserUI()
    }
    
    private func setupAddCardViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        NavigationControllerService.shared.presentAddViewController()
    }
    
    private func setupSearchViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        UserDefaults().saveForceTouchActive(current: true)
        NavigationControllerService.shared.presentCurrentUserUI()
    }
    
    private func setupOpenLastViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let lastCard = loadShortcutItemFromFile()
        NavigationControllerService.shared.presentDetailsViewController(with: lastCard ?? LastCard())
    }
    
    private func loadShortcutItemFromFile() -> LastCard? {
        let manager = FileHandler()
        let lastCard = try? manager.readDataFromPlist()
        return lastCard
    }
}
