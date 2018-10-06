//
//  DetailedViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController { //final

    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var customerNumberLabel: UILabel!
    @IBOutlet private weak var nameImageView: UIImageView!
    
    var barcode: String = "" // access modifiers
    var customerNum: String = ""
    var image: UIImage? = nil {
        didSet {
            print("sdfsdf") // шо це? -таке лишив як було - 
            self.nameImageView.image = image

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("sdfsdf234234")  // шо це?
        self.barcodeLabel.text = barcode
        self.customerNumberLabel.text = customerNum
    }
}
