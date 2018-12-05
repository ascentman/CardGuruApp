//
//  GradientLayer.swift
//  CardGuru
//
//  Created by Vova on 12/4/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class GradientLayer: CAGradientLayer {
    
    init(inFrame: CGRect) {
        super.init()
        let clear = UIColor(white: 1, alpha: 0).cgColor
        //let light = UIColor.groupTableViewBackground.cgColor//UIColor(white: 1, alpha: 0.5).cgColor
        let gray = UIColor.groupTableViewBackground.cgColor//UIColor(white: 1, alpha: 0.9).cgColor 
        colors = [clear, gray]
        frame = CGRect(x: 0, y: 0, width: inFrame.size.width, height: inFrame.size.height)
        startPoint = CGPoint(x: 0.5, y: 0)
        endPoint = CGPoint(x: 0.5, y: 1.0)
//        locations = [0.1, 0.6]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
