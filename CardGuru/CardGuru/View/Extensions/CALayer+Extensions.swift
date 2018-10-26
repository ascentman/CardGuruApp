//
//  CALayer+Extensions.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension CALayer {
    func setImage(named: String) -> UIImage? {
        return UIImage(named: named)?.maskWithColor(color: UIColor.orange)
    }
}
