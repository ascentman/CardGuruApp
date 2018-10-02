//
//  DatabaseService.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Firebase

class DatabaseService {
    
    static let shared = DatabaseService()
    private init() {}
    
    let userRef = Database.database().reference(withPath: "User")
    let settingsRef = Database.database().reference(withPath: "User/Settings")
    let cardsRef = Database.database().reference(withPath: "User/Cards")
    let notessRef = Database.database().reference(withPath: "User/Cards/Notes")
    
    let logoRef = Storage.storage().reference(withPath: "logo.jpg")
    let cardImageRef = Storage.storage().reference(withPath: "cards/\(Int.random(in: 1..<9999)).png")
}
