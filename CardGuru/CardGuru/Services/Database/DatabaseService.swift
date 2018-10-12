//
//  DatabaseService.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Firebase

class DatabaseService { //final
    
    static let shared = DatabaseService()
    private init() {}
    
    let userRef = Database.database().reference(withPath: "Users")
    let settingsRef = Database.database().reference(withPath: "Users/Settings")
    let cardsRef = Database.database().reference(withPath: "User/Cards")
    let notessRef = Database.database().reference(withPath: "User/Cards/Notes")
    
    let logoRef = Storage.storage().reference(withPath: "logo.jpg")
    let cardImageRef = Storage.storage().reference(withPath: "cards/\(Int.random(in: 1..<9999)).png") // це шось погане дуже, може використати назви рандомно генеровані, наприклад UUID().uuidString 1
    /// Create a UUID from a string such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F".
}
