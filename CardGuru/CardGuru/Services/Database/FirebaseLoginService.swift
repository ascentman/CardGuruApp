//
//  FirebaseLoginService.swift
//  CardGuru
//
//  Created by Vova on 10/3/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Firebase

final class FirebaseService {
    
    typealias SignInResponse = (_ user: User, _ error: Error?) -> ()
    static let shared = FirebaseService()
    private init() {}
    
    func setupFirebase() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
    
    func retrieveData(from: String, with token: String, completion: @escaping SignInResponse) {
        var credentials: AuthCredential? = nil
        switch from {
        case LoginMethod.google:
            credentials = GoogleAuthProvider.credential(withIDToken: "", accessToken: token)
        default:
            break
        }
        
        if let credentials = credentials {
            Auth.auth().signInAndRetrieveData(with: credentials) { authResult, error in
                if let name = authResult?.user.displayName,
                    let email = authResult?.user.email,
                    let absoluteURL = authResult?.user.photoURL {
                    let newUser = User(name: name, email: email, absoluteURL: absoluteURL)
                    completion(newUser, error)
                }
            }
        }
    }
}
