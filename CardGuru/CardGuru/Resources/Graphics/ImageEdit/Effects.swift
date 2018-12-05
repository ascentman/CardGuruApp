//
//  Effects.swift
//  CardGuru
//
//  Created by Vova on 12/5/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class Effects {
    
    class func addBlur(for image: UIImage, with radius: Float) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: image)
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        
        var cgImage: CGImage?
        if let outputImage = outputImage {
            cgImage = context.createCGImage(outputImage, from: inputImage?.extent ?? CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        if let cgImage = cgImage {
            return UIImage(cgImage: cgImage, scale: originalScale, orientation: originalOrientation)
        }
        return nil
    }
    
    class func addShadow(for view: UIView) {
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 2.0
        view.layer.shadowRadius = 10.0
        view.layer.masksToBounds = false
    }
}
