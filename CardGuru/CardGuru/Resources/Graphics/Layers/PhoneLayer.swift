//
//  PhoneLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let imageName = "iphone"
}

final class PhoneLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        contents = UIImage(named: Constants.imageName)?.maskWithColor(color: UIColor(red: 239/255, green: 56/255, blue: 82/255, alpha: 1.0)).cgImage
        contentsGravity = CALayerContentsGravity.resizeAspect
        frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        position = CGPoint(x: inFrame.midX, y: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
