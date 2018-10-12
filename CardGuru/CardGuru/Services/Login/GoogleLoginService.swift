//
//  GoogleService.swift
//  CocoaPodsApp
//
//  Created by Vova on 9/21/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import GoogleSignIn

final class GoogleLoginService: NSObject {
    
    typealias SignInResponse = (_ user: User, _ error: Error?) -> ()
    typealias DisconnectResponse = (_ success: Bool, _ error:Error?) -> ()
    typealias Status = () -> ()
    
    static let sharedInstance = GoogleLoginService()
    private var presenter: UIViewController?
    private var singInCompletion: SignInResponse?
    private var disconnectCompletion: DisconnectResponse?
    private var status: Status?

    // чому тут @discardableResult
    @discardableResult func registerInApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"),
            let data = try? Data(contentsOf: url) {
            let dictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String : AnyObject]
            if let clientID = dictionary??["CLIENT_ID"] {
                GIDSignIn.sharedInstance().clientID = clientID as? String
            }
        }
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        return true
    }
    
    func handleURLIn(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    // MARK: - UserManagement
    
    func signIn(_ controller: UIViewController, onRequestStart: Status?, completion: SignInResponse?) {
        status = onRequestStart
        singInCompletion = completion
        presenter = controller
        GIDSignIn.sharedInstance().signIn()
        saveLoggedState(current: true)
    }
    
    func disconnectUser(completion: DisconnectResponse? = nil) {
        disconnectCompletion = completion
        GIDSignIn.sharedInstance().disconnect()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        saveLoggedState(current: false)
    }
    
    func isLoggedIn() -> Bool {
        return GIDSignIn.sharedInstance().hasAuthInKeychain()
    }

    // цей метод не тільки до гугла ж відноситься - те ж саме в тебе і до fb - а якшо буде 40 соціалок - буде 40 методів? шо буде якшо в цих 40 методів назву ключа змінити - будеш всі методи міняти - це хіба ок? думай про розширення відразу
    func saveLoggedState(current: Bool) {
        UserDefaults.standard.set(current, forKey: "isLoggedIn")
    }
}

// MARK: - GIDSignInDelegate

extension GoogleLoginService: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            return //  self.singInCompletion?(user, error) ніколи не повернеться користувачу і буде вічний лоадер
        }
        guard let authentication = user.authentication else {
            return // тут             self.singInCompletion?(user, error) ніколи не повернеться користувачу і буде вічний лоадер
            // думай про рідкісні випадки
        }
        self.status?()
        FirebaseService.shared.retrieveData(from: LoginMethod.google, with: authentication.accessToken, completion: {(user, error) -> () in
            self.singInCompletion?(user, error)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        disconnectCompletion?(error == nil, error)
    }
}

// MARK: - GIDSignInUIDelegate

extension GoogleLoginService: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        presenter?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        presenter = nil
        viewController.dismiss(animated: true, completion: nil)
    }
}
