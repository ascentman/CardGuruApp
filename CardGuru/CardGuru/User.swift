//
//  User.swift
//  CardGuru
//
//  Created by Vova on 9/25/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

class User {
    var name: String
    var email: String
    var imageURL: URL?
    
    init(name: String, email: String, imageURL: URL?) {
        self.name = name
        self.email = email
        self.imageURL = imageURL
    }
    
    convenience init() {
        self.init(name: "", email: "", imageURL: nil)
    }
}
