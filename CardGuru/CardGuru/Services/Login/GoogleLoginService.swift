//
//  GoogleService.swift
//  CocoaPodsApp
//
//  Created by Vova on 9/21/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import GoogleSignIn

enum LoginMethod {
    static let google = "Google"
}

final class GoogleLoginService: NSObject {
    
    typealias SignInResponse = (_ user: User?, _ error: Error?) -> ()
    typealias DisconnectResponse = (_ success: Bool, _ error:Error?) -> ()
    typealias Status = () -> ()
    static let sharedInstance = GoogleLoginService()
    private var presenter: UIViewController?
    private var singInCompletion: SignInResponse?
    private var disconnectCompletion: DisconnectResponse?
    private var status: Status?

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
    
    @discardableResult func handleURLIn(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    // MARK: - UserManagement
    
    func signIn(_ controller: UIViewController, onRequestStart: Status?, completion: SignInResponse?) {
        status = onRequestStart
        singInCompletion = completion
        presenter = controller
        GIDSignIn.sharedInstance().signIn()
        UserDefaults().saveLoggedState(current: true)
    }
    
    func disconnectUser(completion: DisconnectResponse? = nil) {
        disconnectCompletion = completion
        GIDSignIn.sharedInstance().disconnect()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults().saveLoggedState(current: false)
    }
    
    func isLoggedIn() -> Bool {
        return GIDSignIn.sharedInstance().hasAuthInKeychain()
    }
}

// MARK: - GIDSignInDelegate

extension GoogleLoginService: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.singInCompletion?(nil, error)
            return
        }
        guard let authentication = user.authentication else {
            self.singInCompletion?(nil, error)
            return
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

// Extensions

extension GoogleLoginService: GIDSignInUIDelegate {
    
    // MARK: - GIDSignInUIDelegate
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        presenter?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        presenter = nil
        viewController.dismiss(animated: true, completion: nil)
    }
}
