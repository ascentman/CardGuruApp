//
//  User.swift
//  CardGuru
//
//  Created by Vova on 9/25/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

final class User {
    var name: String
    var email: String
    var absoluteURL: URL?
    
    init(name: String, email: String, absoluteURL: URL?) {
        self.name = name
        self.email = email
        self.absoluteURL = absoluteURL
    }
}
