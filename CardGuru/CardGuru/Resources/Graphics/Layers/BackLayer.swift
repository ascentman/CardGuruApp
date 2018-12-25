//
//  BackLayer.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum InnerRectangle {
    static let width = 300.0
    static let height = 180.0
}

final class BackLayer: CAShapeLayer {
    
    init(inFrame: CGRect) {
        super.init()
        path = drawPath(width: Double(inFrame.maxX), heigth: Double(inFrame.maxY)).cgPath
        fillRule = CAShapeLayerFillRule.evenOdd
        fillColor = UIColor.lightGray.cgColor
        opacity = 0.6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawPath(width: Double, heigth: Double) -> UIBezierPath {
        let viewPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: heigth))
        let rect = CGRect(x: width / 2 - InnerRectangle.width / 2,
                          y: heigth / 2 - InnerRectangle.height / 2,
                          width: InnerRectangle.width, height: InnerRectangle.height)
        let rectPath = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        viewPath.append(rectPath)
        viewPath.usesEvenOddFillRule = true
        return viewPath
    }
}
