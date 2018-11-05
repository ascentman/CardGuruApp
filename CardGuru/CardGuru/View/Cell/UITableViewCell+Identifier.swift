//
//  UITableViewCell+Identifier.swift
//  CardGuru
//
//  Created by Vova on 10/16/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    class func identifier() -> String {
        return String(describing: self)
    }
    
    class func nib() -> UINib {
        return UINib.init(nibName: self.identifier(), bundle: nil)
    }
}
