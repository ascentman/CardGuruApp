//
//  LoginMethods.swift
//  CardGuru
//
//  Created by Vova on 10/12/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

enum LoginMethod {
    static let facebook = "Facebook"
    static let google = "Google"
}

enum Permissions {
    static let login = ["public_profile", "email"]
    static let data = ["fields": "email, name, picture.width(480).height(480)"]
}
