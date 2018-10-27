//
//  DetailedViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

private enum Filter {
    static let name = "CICode128BarcodeGenerator"
    static let forKey = "inputMessage"
}

import UIKit

final class DetailedViewController: UIViewController {

    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var name = String()
    private var barcode = String()
    private var barcodeGenerated: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = name
        self.barcodeImageView.image = barcodeGenerated
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setDetailedCard(name: String, barcode: String) {
        self.name = name
        self.barcodeGenerated = generateBarcode(from: barcode)
    }
    
    private func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: Filter.name) {
            filter.setValue(data, forKey: Filter.forKey)
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
