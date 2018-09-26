//
//  GoogleService.swift
//  CocoaPodsApp
//
//  Created by Vova on 9/21/18.
//  Copyright © 2018 Vova. All rights reserved.
//

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
    private var loginManager: LoginManager?
    
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
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        signOutFb()
    }
    
    func signIn(_ controller: UIViewController, completion: SignInResponse?) {
        singInCompletion = completion
        presenter = controller
        GIDSignIn.sharedInstance().signIn()
    }
    
    func disconnectUser(completion: DisconnectResponse? = nil) {
        disconnectCompletion = completion
        GIDSignIn.sharedInstance().disconnect()
    }
    
    func signInFb(_ controller: UIViewController, completion: SignInResponse?) {
        singInCompletion = completion
        presenter = controller
        fbSignInCall()
    }
    
    func signOutFb() {
        loginManager?.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
    }
    
    private func fbSignInCall() {
        loginManager = LoginManager()
        loginManager?.logIn(readPermissions: [.publicProfile, .email], viewController : nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                break
            case .success(_, _, _):
                self.fetchFbData()
            }
        }
    }
    
    private func fetchFbData() {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email, picture.type(large)"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET").start(completionHandler: { (connection, result, error) in
                if error == nil {
                    let fields = result as AnyObject
                    if let firstName = fields.value(forKey: "first_name") as? String,
                        let lastName = fields.value(forKey: "last_name") as? String,
                        let email = fields.value(forKey: "email") as? String,
                        let imageUrl = fields.value(forKeyPath: "picture.data.url") as? String {
                        let newUser = User(name: "\(firstName) \(lastName)", email: email, imageURL: URL(string: imageUrl))
                        self.singInCompletion?(newUser, error)
                    }
                }
            }
        )}
    }
}

// MARK: - GIDSignInDelegate

extension LoginService: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { authResult, error in
            if let name = authResult?.user.displayName,
                let email = authResult?.user.email,
                let imageURL = authResult?.user.photoURL {
                let newUser = User(name: name, email: email, imageURL: imageURL)
                self.singInCompletion?(newUser, error)
            }
        }
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
