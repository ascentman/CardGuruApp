//
//  CardCollectionViewCell.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImageName: UIImageView!
    
    func setCellImage(from: UIImage) {
        cardImageName.image = from
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cardImageName.image = nil
    }
}
