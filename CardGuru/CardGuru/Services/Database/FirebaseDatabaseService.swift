//
//  FirebaseDatabaseService.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import Firebase

private enum Paths {
    static let users = "Users"
    static let cards = "Cards"
}

final class DatabaseService {
    
    static let shared = DatabaseService()
    private init() {}
    let usersRef = Database.database().reference(withPath: Paths.users)
    
    func saveCard(with parameters: [String : Any]) -> String {
        let userRef = getCurrentUserRef()
        let cardRef = usersRef.child(userRef).child(Paths.cards).childByAutoId()
        cardRef.setValue(parameters)
        let cardUID = URL(fileURLWithPath: cardRef.url).lastPathComponent
        return cardUID
    }
    
    func getCurrentUserRef() -> String {
        if let userEmail = UserDefaults().email {
            return userEmail.replacingOccurrences(of: ".", with: "_")
        }
        return String()
    }
    
    func loadDataFromDb(completion: @escaping ([Card])->()) {
        var cards: [Card] = []
        let userRef = getCurrentUserRef()
        usersRef.child(userRef).child(Paths.cards).observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let card = Card(snapshot: snapshot) {
                    cards.append(card)
                }
            }
            completion(cards)
        }
    }
    
    func removeDataFromDb(withUID: String) {
        let userRef = getCurrentUserRef()
        usersRef.child(userRef).child(Paths.cards).child(withUID).removeValue()
    }
    
    func updateDataInDb(forCard: Card) {
        let userRef = getCurrentUserRef()
        usersRef.child(userRef).child(Paths.cards).child(forCard.uid).updateChildValues(["name" : forCard.name,
                                                                                        "barcode" : forCard.barcode])
    }
}
