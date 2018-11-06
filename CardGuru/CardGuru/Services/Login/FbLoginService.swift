//
//  FbLoginService.swift
//  CardGuru
//
//  Created by Vova on 10/3/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin

private enum Permissions {
    static let login = ["public_profile", "email"]
    static let data = ["fields": "email, name, picture.width(480).height(480)"]
}

final class FbLoginService: NSObject {
    
    typealias SignInResponse = (_ user: User?, _ error: Error?) -> ()
    static let sharedInstance = FbLoginService()
    private var presenter: UIViewController?
    private var singInCompletion: SignInResponse?
    private var status: (() -> ())?
    
    @discardableResult func registerInApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    @discardableResult func handleURLIn(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    // MARK: - UserManagement
    
    func signOut() {
        fbSignOutCall()
        UserDefaults().saveLoggedState(current: false)
    }
    
    func signIn(_ controller: UIViewController, onRequestStart: (() -> ())? = nil, completion: SignInResponse?) {
        singInCompletion = completion
        status = onRequestStart
        presenter = controller
        fbSignInCall()
        UserDefaults().saveLoggedState(current: true)
    }
    
    func isLoggedIn() -> Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    // MARK: - Facebook Login
    
    private func fbSignOutCall() {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
    }
    
    private func fbSignInCall() {
        let loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = .systemAccount
        loginManager.logIn(withReadPermissions: Permissions.login, from: nil) { (result, error) in
            if let _ = error {
                self.singInCompletion?(nil, error)
                return
            }
            self.status?()
            if result?.grantedPermissions != nil {
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: Permissions.data)
                graphRequest?.start(completionHandler: { (_, user, error) in
                    if let error = error {
                        self.singInCompletion?(nil, error)
                        return
                    }
                    if let dict = user as? [String : Any],
                        let name = dict["name"] as? String,
                        let email = dict["email"] as? String,
                        let absoluteURL = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        let newUser = User(name: name, email: email, absoluteURL: URL(string: absoluteURL))
                        self.singInCompletion?(newUser, error)
                    }
                })
            } else {
                self.singInCompletion?(nil, error)
                return
            }
        }
    }
}
