//
//  LastCard.swift
//  CardGuru
//
//  Created by Vova on 11/21/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation

final class LastCard: Codable {
    var name: String
    var barcode: String
    var imageData: Data?
    
    init(name: String = "", barcode: String = "", imageData: Data? = nil) {
        self.name = name
        self.barcode = barcode
        self.imageData = imageData
    }
}
