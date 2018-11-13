//
//  UserDefaults+LoginData.swift
//  CardGuru
//
//  Created by Vova on 10/16/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

private enum Constants {
    static let userKey = "User"
    static let isLoggedIn = "isLoggedIn"
    static let touchIDKey = "isTouchIDEnabled"
    static let isLicenceAccepted = "isLicenceAccepted"
    static let isNotificationsTurnedOn = "isNotificationsTurnedOn"
}

extension UserDefaults {

    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isLoggedIn)
        }
    }
    
    var isTouchIDEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.touchIDKey)
        }
    }
    
    var isLicenceAccepted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isLicenceAccepted)
        }
    }
    
    var isNotificationsTurnedOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isNotificationsTurnedOn)
        }
    }
    
    func saveLoggedState(current: Bool) {
        UserDefaults.standard.set(current, forKey: Constants.isLoggedIn)
    }
    
    func saveTouchIdStatus(current: Bool) {
        UserDefaults.standard.set(current, forKey: Constants.touchIDKey)
    }
    
    func saveLicenceStatus(current: Bool) {
        UserDefaults.standard.set(current, forKey: Constants.isLicenceAccepted)
    }
    
    func saveNotificationStatus(current: Bool) {
        UserDefaults.standard.set(current, forKey: Constants.isNotificationsTurnedOn)
    }
    
    func save(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: Constants.userKey)
        }
    }
    
    func fetchUser() -> User? {
        var decodedUser: User?
        let decoder = JSONDecoder()
        if let userData = UserDefaults.standard.value(forKey: Constants.userKey) as? Data {
            if let user = try? decoder.decode(User.self, from: userData) {
                decodedUser = User(name: user.name, email: user.email, absoluteURL: user.absoluteURL)
            }
        }
        return decodedUser
    }
}
