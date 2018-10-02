//
//  DetailedViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var customerNumberLabel: UILabel!
    @IBOutlet private weak var nameImageView: UIImageView!
    
    var barcode: String = ""
    var customerNum: String = ""
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barcodeLabel.text = barcode
        self.customerNumberLabel.text = customerNum
        self.nameImageView.image = image
    }
}
