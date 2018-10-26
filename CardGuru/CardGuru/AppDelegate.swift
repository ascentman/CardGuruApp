//
//  AppDelegate.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase

/*

 UX:

 малюнок з профілю поганої якості - покращити
після зчитування інформації відкривається скрін з результатом - має бути активним курсор для введення імені - так зручніше

 Proj:

Firebase - тиждень пройшов - змін не спостерігається - все ще розкидано по всьому додатку
 storyboard - warnings поправити

 Code:
 // needed to hide keyboard when clicked anywhere on a view - оце дивно - які є альтернативи? чому використаний метод поганий?

 код типу
 DatabaseService.shared.usersRef.child(userRef).child("Cards").childByAutoId().setValue(parameters)
інкапсулювати в метод сервісу для firebase

codeStyle - різні іфдступи пусті рядки - знову повертаємося до старого
 проблеми з соціалками (сервісами) не вирішені

 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var navigationService: NavigationControllerService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        GoogleLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        FbLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        setupInitialViewController()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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
