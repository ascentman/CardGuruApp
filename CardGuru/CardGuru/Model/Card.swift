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
    static let imageURL = "imageURL"
}

final class Card {
    let uid: String
    var name: String
    var barcode: String
    var imageURL: String
    var image: UIImage?
    
    init(uid: String, name: String, barcode: String, image: UIImage, imageURL: String) {
        self.uid = uid
        self.name = name
        self.barcode = barcode
        self.image = image
        self.imageURL = imageURL
    }
    
    convenience init(name: String, barcode: String, image: UIImage) {
        self.init(uid: String(), name: name, barcode: barcode, image: image, imageURL: String())
    }
    
    convenience init(uid: String, name: String, barcode: String, imageURL: String) {
        self.init(uid: uid, name: name, barcode: barcode, image: UIImage(), imageURL: imageURL)
    }
    
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String : AnyObject],
            let name = value[Constants.name] as? String,
            let barcode = value[Constants.barcode] as? String,
            let imageURL = value[Constants.imageURL] as? String else {
            return nil
        }
        self.uid = snapshot.key
        self.name = name
        self.barcode = barcode
        self.imageURL = imageURL
    }
}
