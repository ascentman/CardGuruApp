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
    static let absoluteURL = "absoluteURL"
}

final class Card {
    let uid: String
    var name: String
    var barcode: String
    var image: UIImage?
    var absoluteURL: String?
    var nameColor: UIColor?
    
    init(uid: String, name: String, barcode: String, image: UIImage) {
        self.uid = uid
        self.name = name
        self.barcode = barcode
        self.image = image
        self.absoluteURL = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String : AnyObject],
            let name = value[Constants.name] as? String,
            let barcode = value[Constants.barcode] as? String else {
            return nil
        }
        self.uid = snapshot.key
        self.name = name
        self.barcode = barcode
        if let absoluteURL = value[Constants.absoluteURL] as? String {
            self.absoluteURL = absoluteURL
        }
    }
}
