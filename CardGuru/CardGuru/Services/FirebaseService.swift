//
//  FirebaseService.swift
//  CardGuru
//
//  Created by Vova on 10/3/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService { // final

    // сервіс є але все розкидано з firebase по проекту - дуже погано!
    
    
    typealias SignInResponse = (_ user: User, _ error: Error?) -> ()
    
    static let shared = FirebaseService()
    private init() {}
    
    func retrieveData(from: String, with token: String, completion: @escaping SignInResponse) {
        var credentials: AuthCredential? = nil
        
        switch from {
        case Constants.LoginMethod.facebook:
            credentials = FacebookAuthProvider.credential(withAccessToken: token)
        case Constants.LoginMethod.google:
            credentials = GoogleAuthProvider.credential(withIDToken: "", accessToken: token)
        default:
            break
        }
        
        if let credentials = credentials {
            Auth.auth().signInAndRetrieveData(with: credentials) { authResult, error in
                if let name = authResult?.user.displayName,
                    let email = authResult?.user.email,
                    let imageURL = authResult?.user.photoURL {
                    let newUser = User(name: name, email: email, imageURL: imageURL)
                    completion(newUser, error)
                }
            }
        }
    }
}
