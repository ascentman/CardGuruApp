//
//  BackLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum InnerRectangle {
    case width
    case height
    
    func get() -> CGFloat {
        switch self {
        case .width:
            return 300
        case .height:
            return 180
        }
    }
}

class BackLayer: CAShapeLayer {
    
    init(inFrame: CGRect) {
        super.init()
        
        path = drawPath(width: inFrame.maxX, heigth: inFrame.maxY).cgPath
        fillRule = CAShapeLayerFillRule.evenOdd
        fillColor = UIColor.lightGray.cgColor
        opacity = 0.6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawPath(width: CGFloat, heigth: CGFloat) -> UIBezierPath {
        let viewPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: heigth))
        let rectPath = UIBezierPath(rect: CGRect(x: width / 2 - InnerRectangle.width.get() / 2,
                                                 y: heigth / 2 - InnerRectangle.height.get() / 2,
                                                 width: InnerRectangle.width.get(), height: InnerRectangle.height.get()))
        viewPath.append(rectPath)
        viewPath.usesEvenOddFillRule = true
        return viewPath
    }
}
