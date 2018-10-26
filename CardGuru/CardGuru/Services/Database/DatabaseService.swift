//
//  DatabaseService.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Firebase

final class DatabaseService {
    
    static let shared = DatabaseService()
    private init() {}
    
    let usersRef = Database.database().reference(withPath: "Users")
}
