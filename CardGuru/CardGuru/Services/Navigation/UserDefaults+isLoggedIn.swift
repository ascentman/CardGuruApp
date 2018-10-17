//
//  UserDefaults+isLoggedIn.swift
//  CardGuru
//
//  Created by Vova on 10/16/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

extension UserDefaults {
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
}
