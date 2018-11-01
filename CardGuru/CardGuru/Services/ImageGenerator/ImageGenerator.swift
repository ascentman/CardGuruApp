//
//  ImageGenerator.swift
//  CardGuru
//
//  Created by Vova on 10/31/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class ImageGenerator {
    
    static let shared = ImageGenerator()
    private init() {}
    
    func textToImage(drawText text: String, inImage image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), blendMode: .normal, alpha: 0.4)
        var fontSize: CGFloat = 140
        switch text.count {
        case 1...3:
            fontSize = 220
        case 4...5:
            fontSize = 160
        case 6...7:
            fontSize = 120
        case 8...9:
            fontSize = 100
        case 10...11:
            fontSize = 80
        default:
            fontSize = 40
        }
        
        let font = UIFont(name: "Mauryssel-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment=NSTextAlignment.center
        let textColor = UIColor.purple
        let attributes = [NSAttributedString.Key.font : font,
                          NSAttributedString.Key.paragraphStyle : textStyle,
                          NSAttributedString.Key.foregroundColor:textColor]
        
        let textHeight = font.lineHeight
        let textYpos = (image.size.height - textHeight) / 2
        let textRect = CGRect(x: 0, y: textYpos, width: image.size.width, height: textHeight)
        text.uppercased().draw(in: textRect.integral, withAttributes: attributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
