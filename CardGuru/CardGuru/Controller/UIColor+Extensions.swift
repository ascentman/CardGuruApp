//
//  UIColor+Extensions.swift
//  CardGuru
//
//  Created by Vova on 10/12/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: String {
        let r:CGFloat = .random(in: 0...0.9)
        let g:CGFloat = .random(in: 0...0.9)
        let b:CGFloat = .random(in: 0...0.9)
        
        var color = String(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        color += String(format: "%02lX", lroundf(Float(0.9)))
        return color
    }
}
