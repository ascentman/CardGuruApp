//
//  UserDefaults+LoginData.swift
//  CardGuru
//
//  Created by Vova on 10/16/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

extension UserDefaults {

    func saveLoggedState(current: Bool) {
        UserDefaults.standard.set(current, forKey: "isLoggedIn")
    }
    
    func save(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "User")
        }
    }
    
    func fetchUser() -> User? {
        var decodedUser: User?
        let decoder = JSONDecoder()
        if let userData = UserDefaults.standard.value(forKey: "User") as? Data {
            if let user = try? decoder.decode(User.self, from: userData) {
                decodedUser = User(name: user.name, email: user.email, absoluteURL: user.absoluteURL)
            }
        }
        return decodedUser
    }
}
