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
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
        
    func setCell(name: String, image: UIImage) {
        cellName.text = name
        cellImage.image = image
        loadingIndicator.stopAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.startAnimating()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellName.text = nil
        cellImage.image = nil
    }
}
