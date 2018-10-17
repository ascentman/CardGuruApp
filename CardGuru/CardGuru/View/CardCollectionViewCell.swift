//
//  CardCollectionViewCell.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var cellName: UILabel!
    
    func setCellName(from: String) {
        cellName.text = from
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellName.text = nil
    }
}
