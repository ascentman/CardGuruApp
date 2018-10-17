//
//  UserDefaults+LoginData.swift
//  CardGuru
//
//  Created by Vova on 10/16/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

extension UserDefaults {
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: "name")
        }
    }
    
    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: "email")
        }
    }
    
    var logo: Data? {
        get {
            return UserDefaults.standard.data(forKey: "logo")
        }
    }
    
    func setName(name: String) {
        UserDefaults.standard.set(name, forKey: "name")
    }
    
    func setEmail(name: String) {
        UserDefaults.standard.set(name, forKey: "email")
    }
    
    func setLogo(name: Data) {
        UserDefaults.standard.set(name, forKey: "logo")
    }
    
}
