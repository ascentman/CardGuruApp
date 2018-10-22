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
 fb login with fb app не робить - відео 1
після натискання + зависає секунд на 15
 пуш анімація скріна з камерою робить не ок - див відео 2
 скрол таблички - деревяний - бо в тебе 100% завантаження cpu постійно - скріншот 1
 кнопка зявляється без анімації на скріні з камерою
 якшо я заборонив доступ до камери - то потім ап не інформує про це - додати попап з інформацією і пропозицією перейти в налаштування додатку щоб надати доступ, якшо користувач натисне ні - відкрити введення вручну відразу
 малюнок з профілю поганої якості - покращити
 таб бар має бути видимим лише на початкових скрінах - списку карток і bookmarks
 перейменувати меню там бару і поставити власний малюнок - зробити cards/settings
після зчитування інформації відкривається скрін з результатом - має бути активним курсор для введення імені - так зручніше

 Proj:
 файли сервісів всі в папці Login
 Animations - функції ж можуть бути функціями класу
 Layers - взагалі логіка незрозуміла - в тебе 1 клас тримає посилання на обєкти для всього додатку - переробити таким чином шоб кожен контролер відповідав за свої обєкти - жах
 func maskWithColor(color: UIColor) -> UIImage { - о божечки - чому?
Firebase - тиждень пройшов - змін не спостерігається - все ще розкидано по всьому додатку
 storyboard - warnings поправити

 Code:
 // needed to hide keyboard when clicked anywhere on a view - оце дивно - які є альтернативи? чому використаний метод поганий?

 код типу
 DatabaseService.shared.usersRef.child(userRef).child("Cards").childByAutoId().setValue(parameters)
інкапсулювати в метод сервісу для firebase

 userEmail.replacingOccurrences(of: ".", with: "_") - це кандидат на метод в extension - в ідеалі треба regex для перевірки формату email
codeStyle - різні іфдступи пусті рядки - знову повертаємося до старого
 проблеми з соціалками (сервісами) не вирішені

 */

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
