//
//  CardCollectionViewCell.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var cellImageName: UIImageView!
    
    func setCellImage(from: UIImage) {
        cellImageName.image = from
    }

    // prepareForReuse
    //awake from nib - налаштування - де це?
}
