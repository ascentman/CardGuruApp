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
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var name: String = ""
    private var barcode: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = name
        self.barcodeLabel.text = barcode
    }
    
    func setDetailedCard(name: String, barcode: String) {
        self.name = name
        self.barcode = barcode
    }
}
