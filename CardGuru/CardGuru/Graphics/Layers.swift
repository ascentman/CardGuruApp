//
//  Layers.swift
//  CardGuru
//
//  Created by Vova on 10/18/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class Layers {
    private var phoneLayer: CALayer?
    private var checkLayer: CALayer?
    private var cardLayer: CALayer?
    private var squareLayer: CALayer?
    private var backLayer: CAShapeLayer?
    
    func setPhoneLayer(for view: UIView) {
        let phoneImage = UIImage(named: "iphone")?.maskWithColor(color: UIColor.orange).cgImage
        self.phoneLayer = CALayer()
        guard let phoneLayer = phoneLayer else {
            return
        }
        phoneLayer.contents = phoneImage
        phoneLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        phoneLayer.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        phoneLayer.position = CGPoint(x: view.frame.midX, y: view.frame.minY + 150)
        view.layer.addSublayer(phoneLayer)
    }
    
    func setCardLayer(for view: UIView) -> CALayer {
        let cardImage = UIImage(named: "card")?.maskWithColor(color: UIColor.orange).cgImage
        cardLayer = CALayer()
        guard let cardLayer = cardLayer else {
            return CALayer()
        }
        cardLayer.contents = cardImage
        cardLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        cardLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        cardLayer.position = CGPoint(x: view.frame.maxX + 100, y: view.frame.minY + 150)
        return cardLayer
    }
    
    func setCheckLayer(for view: UIView) -> CALayer {
        let checkImage = UIImage(named: "check")?.maskWithColor(color: UIColor.orange).cgImage
        checkLayer = CALayer()
        guard let checkLayer = checkLayer else {
            return CALayer()
        }
        checkLayer.contents = checkImage
        checkLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        checkLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        checkLayer.position = CGPoint(x: view.frame.midX, y: view.frame.minY + 150)
        return checkLayer
    }
    
    func setSquareLayer(for view: UIView) {
        squareLayer = CALayer()
        let barcodeImage = UIImage(named: "barcode")?.image(alpha: 0.3)?.cgImage
        guard let squareLayer = squareLayer else {
            return
        }
        squareLayer.borderColor = UIColor.orange.cgColor
        squareLayer.contents = barcodeImage
        squareLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        squareLayer.opacity = 0.5
        squareLayer.borderWidth = 4
        squareLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 180)
        squareLayer.position = view.center
        view.layer.addSublayer(squareLayer)
    }
    
    func setBackLayer(for view: UIView) {
        let viewPath = UIBezierPath(rect: view.frame)
        let rectPath = UIBezierPath(rect: CGRect(x: view.bounds.width / 2 - 150, y: view.bounds.height / 2 - 90, width: 300, height: 180))
        viewPath.append(rectPath)
        viewPath.usesEvenOddFillRule = true
        backLayer = CAShapeLayer()
        guard let backLayer = backLayer else {
            return
        }
        backLayer.path = viewPath.cgPath
        backLayer.fillRule = CAShapeLayerFillRule.evenOdd
        backLayer.fillColor = UIColor.lightGray.cgColor
        backLayer.opacity = 0.6
        view.layer.addSublayer(backLayer)
    }
}
