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

final class SquareLayer: CALayer {
    
    init(inFrame: CGRect) {
        super.init()
        opacity = 1.0
        borderWidth = 3
        borderColor = UIColor.clear.cgColor
        frame = CGRect(x: 0, y: 0, width: 300, height: 180)
        position = CGPoint(x: inFrame.midX, y: inFrame.midY)
        addRoundedRect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func drawPath(width: Double, heigth: Double) -> UIBezierPath {
        let rect = CGRect(x: 0, y: 0, width: width, height: heigth)
        let rounderRect = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        return rounderRect
    }
    
    private func addRoundedRect() {
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 4.0
        shape.path = drawPath(width: 300, heigth: 180).cgPath
        shape.fillColor = UIColor.clear.cgColor
        addSublayer(shape)
    }
}
