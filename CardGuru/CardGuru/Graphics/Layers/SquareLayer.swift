//
//  SquareLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let barcode = "barcode"
}

private enum Frame {
    case x
    case y
    
    func get() -> CGFloat {
        switch self {
        case .x:
            return 300
        case .y:
            return 180
        }
    }
}

class SquareLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        contents = CALayer().setImage(named: Constants.barcode)?.cgImage
        contentsGravity = CALayerContentsGravity.resizeAspectFill
        borderColor = UIColor.orange.cgColor
        opacity = 0.2
        borderWidth = 4
        frame = CGRect(x: 0, y: 0, width: Frame.x.get(), height: Frame.y.get())
        position = CGPoint(x: inFrame.midX, y: inFrame.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
