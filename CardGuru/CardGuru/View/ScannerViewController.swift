//
//  ScannerViewController.swift
//  CardGuru
//
//  Created by Vova on 10/17/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScannerService.shared.setupSession()
        ScannerService.shared.delegate = self
        if let videoLayer = ScannerService.shared.setupVideoLayer() {
            videoLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoLayer)
        }
        ScannerService.shared.session?.startRunning()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddingNewCard,
            let barcode = sender as? String {
            destination.setBarcode(from: barcode)
        }
    }
}

extension ScannerViewController: ScannerServiceDelegate {
    func get(barcode: String) {
        performSegue(withIdentifier: "AddNewCard", sender: barcode)
    }
}
