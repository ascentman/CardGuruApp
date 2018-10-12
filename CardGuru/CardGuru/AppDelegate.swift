//
//  AppDelegate.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase

// fb додаток ще в dev процесі - треба в public перевести шоб мож було спробувати
// перший раз якшо запустити то скрін пустий і якшо клікнути з табки на табку то буде якийсь блінк і потім зявляться картки якість - я ж нічого не додавав

// button "+", enter all data, save -> crash - якщо ввести всю інформацію
//             let imageData = try? Data(contentsOf: URL(string: image)!) - force UNWRAP! - то все повидаляти ці всі force - 100500 раз обговорювали



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var navigationService: NavigationControllerService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GoogleLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        FbLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        setupInitialViewController()
        return true
    }
    
    // MARK: Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        NavigationControllerService.shared.presentCurrentUserUI()
    }
}
