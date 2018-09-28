//
//  GoogleService.swift
//  CocoaPodsApp
//
//  Created by Vova on 9/21/18.
//  Copyright © 2018 Vova. All rights reserved.
//

/**
==========================================================
 FOR DEBUG:
 created Facebook test user: test_ssgzmom_user@tfbnw.net / Zxcv1234
===========================================================
*/

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin

final class LoginService: NSObject {
    
    typealias SignInResponse = (_ user: User, _ error: Error?) -> ()
    typealias DisconnectResponse = (_ success: Bool, _ error:Error?) -> ()
    
    static let sharedInstance = LoginService()
    private var presenter: UIViewController?
    private var singInCompletion: SignInResponse?
    private var disconnectCompletion: DisconnectResponse?
    
    @discardableResult func registerInApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        return true
    }
    
    func handleURLIn(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func handleFbURLIn(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    // MARK: - UserManagement
    
    func signIn(_ controller: UIViewController, completion: SignInResponse?) {
        singInCompletion = completion
        presenter = controller
        GIDSignIn.sharedInstance().signIn()
    }
    
    func disconnectUser(completion: DisconnectResponse? = nil) {
        disconnectCompletion = completion
        GIDSignIn.sharedInstance().disconnect()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        fbSignOutCall()
    }
    
    func signInFb(_ controller: UIViewController, completion: SignInResponse?) {
        singInCompletion = completion
        presenter = controller
        fbSignInCall()
    }
    
    func isLoggedIn() -> Bool {
        return FBSDKAccessToken.current() != nil || GIDSignIn.sharedInstance().hasAuthInKeychain()
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
            if let error = error {
                print(error)
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self.retrieveDataWith(credential)
        }
    }
    
    private func retrieveDataWith(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { authResult, error in
            if let name = authResult?.user.displayName,
                let email = authResult?.user.email,
                let imageURL = authResult?.user.photoURL {
                let newUser = User(name: name, email: email, imageURL: imageURL)
                self.singInCompletion?(newUser, error)
            }
        }
    }
}

// MARK: - GIDSignInDelegate

extension LoginService: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        retrieveDataWith(credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        disconnectCompletion?(error == nil, error)
    }
}

// MARK: - GIDSignInUIDelegate

extension LoginService: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        presenter?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        presenter = nil
        viewController.dismiss(animated: true, completion: nil)
    }
}
