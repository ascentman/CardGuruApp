//
//  SquareLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let imageName = "barcode"
}

class SquareLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        contents = UIImage(named: Constants.imageName)?.maskWithColor(color: UIColor.orange).cgImage
        contentsGravity = CALayerContentsGravity.resizeAspectFill
        borderColor = UIColor.orange.cgColor
        opacity = 0.2
        borderWidth = 4
        frame = CGRect(x: 0, y: 0, width: 300, height: 180)
        position = CGPoint(x: inFrame.midX, y: inFrame.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
