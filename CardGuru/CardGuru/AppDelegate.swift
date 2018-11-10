//
//  AppDelegate.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

/**

 git:

 - ну о - вже стало шось схоже на нормальний процес - все ще є куди рухатися - ціль - кожен день завершувати комітом на гілці спеціально для даного завдання
 - назви комітів - завжди для себе перед створенням повідомлення для комітів додавай "commit is about to... <MESSAGE>" в тебе наприклад - "corrected button layout, added final to some classes" -  не дуже

 logic:
 -     func setupSession(with completion: ((Bool) -> ())) { - як робив кілька функцій так і робить - треба зробити так як я говорив - ScannerService все ще потребує роботи
- generateBarcode - винести в окремий файл - шо ти робитимеш якшо треба буде ще на одному скріні це й самий функціонал буде скопійовано
 -     private var uid = String() - default параметр може бути підступним в такому використанні - якшо це обовязково - то не дозволяй створити обєкт без цих даних

 
 codeStyle
 - якшо тестуєш шось то чистити не забувай - див код нижче
 -     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool { - краще звісно завжди мати 1 вихід з функції - легше дебажити - але не принципово
 - "}
 else" - мало б було бути "} else" - на одному рядку зігдіно з codeStyle
 - модифікатори доступу і типу пропущені (final, private і тп) - AnimatedView, CardCollectionViewCell
 - порядок написаних методів/функцій - спочатку lifeCycle - потім action, internal provate - CardCollectionViewCell
 - повідомлення nbge  Thank you, bro - не дуже припустимі для додатку - можна забути і так піде в реліз - будуть проблеми ну і тут же коментар пісял того як нтиснув вже раз accept то нашо другий і третій раз показувати ту кнопку?
 -     private let tableHeaderHeight: CGFloat = 150.0 - це більше схоже на константу а не на властивість
 -  print("scanning...") -  і все вінше має бути відсутнє в недебаг версії
 - " } else {
 self.singInCompletion?(nil, error)
 return
 }" - в цьому випадку return не треба (останній case)
 - "        imageRef.delete()
 }


 }
" - якість пусті рядки

 
UI/UX
 - камера - як я додав властивість -     let queue = DispatchQueue(label: "com.CardGuru.camera.queue")
так вона там так і лежить - а перейменувати нормально і додати модифікатор 
 
 - touch id не заробило шось в мене - не дебажив - скріншот 2 - чому взагалі інший UI? - за умовою такого не передбачалося
 - navigationBar на setting - сірий а мав би бути жовтим - під стиль всього додатку
 - малюнки на картці відображаться некоректно - див скріншот 1
 - малюнки не зберегіються після перелогінювання
 - дуже довга назва негарно відображається 0 скріншот 3
- якшо зробити delete card з 1-єю карткою то повертаюся на скрін Home де відстунє tabBAt - скріншот 4
- після privacyPolicy - nav Bar неправильного кольору - скріншот 5
- на анімація картка заходить під телефон - а має бути над -  - скріншот 6


 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var navigationService: NavigationControllerService? // ніде не використовуєтсья
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // шо це таке?
        //- >>>
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        //- <<<<

        FirebaseService.shared.setupFirebase()
        GoogleLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        FbLoginService.sharedInstance.registerInApplication(application, didFinishLaunchingWithOptions: launchOptions)
        setupInitialViewController()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if GoogleLoginService.sharedInstance.handleURLIn(app, open: url, options: options) {
            return true
        }
        else if FbLoginService.sharedInstance.handleURLIn(app, open: url, options: options) {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        NavigationControllerService.shared.presentCurrentUserUI()
    }
}
