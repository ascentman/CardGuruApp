//
//  DetailedViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class DetailedViewController: UIViewController {

    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var customerNumberLabel: UILabel!
    @IBOutlet private weak var nameImageView: UIImageView!
    
    var barcode: String = "" // access modifiers
    var customerNum: String = ""
    var image: UIImage? = nil {
        didSet {
            self.nameImageView.image = image
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barcodeLabel.text = barcode
        self.customerNumberLabel.text = customerNum
    }
}
