//
//  UIImage+Extension.swift
//  CardGuru
//
//  Created by Vova on 10/16/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}
