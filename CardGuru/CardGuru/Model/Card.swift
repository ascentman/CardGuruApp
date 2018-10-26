//
//  Card.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase

private enum Constants {
    static let name = "name"
    static let barcode = "barcode"
}

final class Card {
    let name: String
    let barcode: String
    
    init(_ name: String, barcode: String) {
        self.name = name
        self.barcode = barcode
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String : AnyObject],
        let name = value[Constants.name] as? String,
        let barcode = value[Constants.barcode] as? String else {
            return nil
        }
        self.name = name
        self.barcode = barcode
    }
}
