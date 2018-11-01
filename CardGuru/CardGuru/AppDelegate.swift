//
//  AppDelegate.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

/**
 питання, що залишилися:
 - анімація картки, коли повертаюся з сетінгів - ніяк не вдається зробити рух картки "нормальним"
 */

/*
--------------------------------------------------------------------------------------------------------------------------------------------
 git
    - ну нарешті я побачив гілки - все таки вони існують :)
    було б круто якби кожен день ми мали б гілку з певним функціоналом а на 1 гілка на тиждень
--------------------------------------------------------------------------------------------------------------------------------------------
 codeStyle
    - переглянь - ще є відсутні модифікатори доступу на класах функціях
         @IBOutlet weak var barcodeLabel: UILabel!
         @IBOutlet weak var barcodeImageView: UIImageView!

    - є 2 пустих рядка, наприклад
             }


             class LoginBackgroundLayer: CALayer {
    - назви
             private enum Constants {
             static let iphone = "iphone"
             }

             от шо тут озеачає константа iphone? я хз
    - 2 папки Extensions - чому? в одній не вистачає місця ? )
    - о боже - шо ж ти робиш
             extension CALayer {
             func setImage(named: String) -> UIImage? {
                    return UIImage(named: named)?.maskWithColor(color: UIColor.orange)
             }
             }
    - нашо в layer drawInRect - layer робить на gpu а ти прямо таки кажеш - нахрен - давай cpu - виправити!!!!!
    - нащо класи які не використовуються
             extension UITableViewCell {

             class func identifier() -> String {
             return String(describing: self)
             }

             class func nib() -> UINib {
             return UINib.init(nibName: self.identifier(), bundle:nil)
             }
             }
--------------------------------------------------------------------------------------------------------------------------------------------
 logic

 extension UIViewController {

 //MARK: Settings Alert View Controller

 - це жах - всі контролери мають доступ до одного і того ж попапу яктй відкриває якийсь скрін - треба шоб попап повертав completion на cancel чи ok і в місці де він був викликаний приймалося ріщення що тоді робити - інакше немає сенсу таке писати
- requestCameraAccess - хіба це точно питає дозвіл на камеру? здається якшо я перший раз запущу додаток - то доступу не отримаю
- причина висяка на 10 сек при відкритті контролера з камерою - це спагеті-код
    в тебе метод пише шо робить setup а сам перевіряє доступ і ЗАВЖДИ!!!! робить setup - можна чи ні
    і другий момент - ти все робиш в потоці main - а треба в серійному і не головному - як тільки виправиш - все буде робити без лагів (я спробував в себе все ок)
 - багато до функія робить не тільки те шо вона має робити (згідно назви)
 приклад -     @IBAction private func saveClicked(_ sender: Any) {
 тут і зберегіання і валідація і навігація - такого не має бути - треба розділити всю логіку
 - ScannerService - треба переписати або прийнаймні розділити логіку в методах 1 метод -1 функція і зробити правильне використання компонентів
 - ти де не де видумовуєш свій велосипед, хоча поруч стоїть вже новенткий -
    приклад
                 private enum Frame {
                 case x
                 case y

                 func get() -> CGFloat {
                 switch self {
                 case .x:
                 return 300
                 case .y:
                 return 180
                 }
                 }
                 }
    а чим CGPOint не підходить чи CGRect? нащо це?
І до того ж воно ще й дублюється в різних класах з різними значеннями і різними полями - шоб взагалі не сахар було життя в того хто цей код буде правити - чого не використати константи просто 3 штуки чи вищезнадані структури даних - нашо цскладнювати прості речі і робити їх незрощзумілими
 private enum Frame { - випиляти повністю з  проекту - шоб цього не було

 - методи які повертають optinal повертають хоть-шо
         func setupVideoLayer() -> CALayer? {
         if let session = self.session {
         videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
         videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
         return videoPreviewLayer
         }
         return CALayer()
         }
 чому так?
- UserDefaults використовується для зберегігання обєкту користувача (його деталей) - краще тоді серіалізувати модель і зберегти її на диск і потім зчитати - використиай Codable протокол
 - registerInApplication - в обох випадках не опрацьовується результат реєстрації соціалок натомість завжди повертається true
 registerInApplication повертає bool
 - enum Permissions  - тільки для Fb - треба знач інкапсулювати його в Fb сервісі - нашо всьому апу знати про то
 - class Animations { - нашо там singleton - там треба class func натомість і все
 
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
