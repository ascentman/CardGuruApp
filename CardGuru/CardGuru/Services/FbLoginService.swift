//
//  FbLoginService.swift
//  CardGuru
//
//  Created by Vova on 10/3/18.
//  Copyright © 2018 Vova. All rights reserved.
//

/**
 ==========================================================
 FOR DEBUG:
 created Facebook test user: test_ssgzmom_user@tfbnw.net / Zxcv1234
 ===========================================================
 */

import UIKit
import FBSDKLoginKit
import FacebookLogin

final class FbLoginService: NSObject {
    
    typealias SignInResponse = (_ user: User, _ error: Error?) -> ()
    
    static let sharedInstance = FbLoginService()
    private var presenter: UIViewController?
    private var singInCompletion: SignInResponse?
    private var status: (() -> ())?
    
    @discardableResult func registerInApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func handleURLIn(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    // MARK: - UserManagement
    
    func signOut() {
        fbSignOutCall()
        saveLoggedState(current: false)
    }
    
    func signIn(_ controller: UIViewController, onRequestStart: (() -> ())? = nil, completion: SignInResponse?) {
        singInCompletion = completion
        status = onRequestStart

        presenter = controller
        fbSignInCall()
        saveLoggedState(current: true)
    }
    
    func isLoggedIn() -> Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func saveLoggedState(current: Bool) {
        UserDefaults.standard.set(current, forKey: "isLoggedIn")
    }
    
    // MARK: - Facebook Login
    
    private func fbSignOutCall() {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
    }
    
    private func fbSignInCall() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: nil) { (result, error) in
            if let _ = error {
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                return
            }
            self.status?()
            FirebaseService.shared.retrieveData(from: Constants.LoginMethod.facebook, with: accessToken.tokenString, completion: {(user, error) -> () in
                self.singInCompletion?(user, error)
            })
        }
    }
}
