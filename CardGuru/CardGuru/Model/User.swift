//
//  User.swift
//  CardGuru
//
//  Created by Vova on 9/25/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

final class User: Codable {
    var name: String
    var email: String
    var absoluteURL: String?
    
    init(name: String, email: String, absoluteURL: String?) {
        self.name = name
        self.email = email
        self.absoluteURL = absoluteURL
    }
}
