//
//  ScannerViewController.swift
//  CardGuru
//
//  Created by Vova on 10/17/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum SequeName {
    static let addNewCard = "AddNewCard"
}

protocol ScannerViewControllerDelegate: class {
    func userDidEnterCard(_ card: Card)
}

final class ScannerViewController: UIViewController {
    
    @IBOutlet weak var animatedView: AnimatedView!
    @IBOutlet weak var userView: UIView!
    weak var delegate: ScannerViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScannerService.shared.setupSession { (cameraGranted) in
            if !cameraGranted {
                animatedView.backgroundColor = UIColor.black
                requestCameraAccess()
            }
        }
        if let videoLayer = ScannerService.shared.setupVideoLayer() {
            videoLayer.frame = view.layer.bounds
            view.layer.insertSublayer(videoLayer, at: 0)
        }
        ScannerService.shared.session?.startRunning()
        ScannerService.shared.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.transition(with: self.userView, duration: 2.0, options: UIView.AnimationOptions.transitionFlipFromBottom, animations: {
                self.userView.isHidden = false
            }, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        animatedView.removeFromSuperview()
    }

    @IBAction func enterClicked(_ sender: Any) {
        performSegue(withIdentifier: SequeName.addNewCard, sender: nil)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddingNewCard,
            let barcode = sender as? String {
            destination.setBarcode(from: barcode)
            destination.delegate = self
        }
        if let destination = segue.destination as? AddingNewCard {
            destination.delegate = self
        }
    }
    
    private func requestCameraAccess() {
        presentAlert(withTitle: "Camera access", message: "The CardGuru needs camera access. Enable it in Settings to continue")
    }
}

// Extensions

extension ScannerViewController: ScannerServiceDelegate {

    // MARK: - ScannerServiceDelegate

    func get(barcode: String) {
        performSegue(withIdentifier: SequeName.addNewCard, sender: barcode)
    }
}

extension ScannerViewController: AddingNewCardDelagate {

     // MARK: - AddingNewCardDelagate
    
    func userDidEnterData(card: Card) {
        delegate?.userDidEnterCard(card)
    }
}
