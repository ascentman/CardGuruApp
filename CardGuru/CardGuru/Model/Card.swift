//
//  Card.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase

class Card {
    let name: String
    var image: String?
    let barcode: String
    let customerNumber: String
    
    init(_ name: String, barcode: String, _ customerNumber: String) {
        self.name = name
        self.barcode = barcode
        self.customerNumber = customerNumber
        self.image = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String : AnyObject],
        let name = value["name"] as? String,
        let barcode = value["barcode"] as? String,
        let image = value["image"] as? String,
        let customerNumber = value["customerNumber"] as? String else {
            return nil
        }
        self.name = name
        self.barcode = barcode
        self.customerNumber = customerNumber
        self.image = image
    }
}
