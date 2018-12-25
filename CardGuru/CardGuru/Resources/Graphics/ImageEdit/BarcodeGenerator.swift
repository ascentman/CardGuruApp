//
//  BarcodeGenerator.swift
//  CardGuru
//
//  Created by Vova on 11/12/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit


private enum Filter {
    static let name = "CICode128BarcodeGenerator"
    static let forKey = "inputMessage"
}

final class BarcodeGenerator {
    
    class func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: Filter.name) {
            filter.setValue(data, forKey: Filter.forKey)
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
