//
//  ScannerViewController.swift
//  CardGuru
//
//  Created by Vova on 10/17/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let addNewCard = "AddNewCard"
    static let alertTitle = NSLocalizedString("Camera access", comment: "")
    static let alertMessage = NSLocalizedString("The CardGuru needs camera access. Enable it in Settings to continue", comment: "")
    static let acceptTitle = NSLocalizedString("Settings", comment: "")
    static let cancelTitle = NSLocalizedString("Cancel", comment: "")
}

protocol ScannerViewControllerDelegate: class {
    func userDidEnterCard(_ card: Card)
}

protocol AddCardManuallyDelegate: class {
    func userDidEnterData(card: Card)
}

final class ScannerViewController: UIViewController {
    
    @IBOutlet private weak var animatedView: AnimatedView!
    @IBOutlet private weak var userView: UIView!
    private var manualCardAddingView: ManualCard?
    @IBOutlet private weak var sourceIndicatorControl: UISegmentedControl!
    weak var delegate: ScannerViewControllerDelegate?
    weak var addManuallyDelegate: AddCardManuallyDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        ScannerService.shared.setupSession { success in
            if !success {
                self.animatedView.backgroundColor = UIColor.lightGray
                self.requestCameraAccess()
            }
        }
        ScannerService.shared.setupVideoLayer(on: view)
        ScannerService.shared.delegate = self
        
        DispatchQueue.global().async {
            ScannerService.shared.session?.startRunning()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.transition(with: self.userView, duration: 2.0, options: UIView.AnimationOptions.transitionFlipFromBottom, animations: {
                self.userView.isHidden = false
            }, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        animatedView.removeFromSuperview()
        ScannerService.shared.session?.stopRunning()
        
    }

    @IBAction func indexChangeClicked(_ sender: Any) {
        switch sourceIndicatorControl.selectedSegmentIndex {
        case 0:
            manualCardAddingView?.removeFromSuperview()
        case 1:
            addManualCardView(on: view)
        default:
            break
        }
    }
    
    // MARK: - Segues

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? AddCardViewController,
//            let barcode = sender as? String {
//            destination.setBarcode(from: barcode)
//            destination.delegate = self
//        }
//        if let destination = segue.destination as? AddCardViewController {
//            destination.delegate = self
//        }
//    }
    
    // MARK: - Private
    
    private func requestCameraAccess() {
        presentAlert(Constants.alertTitle, message: Constants.alertMessage, acceptTitle: Constants.acceptTitle, declineTitle: Constants.cancelTitle, okActionHandler: {
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }, cancelActionHandler: {
            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: Constants.addNewCard, sender: nil)
                self.sourceIndicatorControl.selectedSegmentIndex = 1
                self.addManualCardView(on: self.view)
            }
        })
    }
    
    private func setupNavigationBar() {
        setupBackItem(with: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func addManualCardView(on view: UIView) {
        manualCardAddingView = ManualCard()
        guard let cardView = manualCardAddingView else {
            return
        }
        cardView.frame = self.userView.frame
        view.addSubview(cardView)
    }
}

// Extensions

extension ScannerViewController: ScannerServiceDelegate {

    // MARK: - ScannerServiceDelegate

    func get(barcode: String) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Constants.addNewCard, sender: barcode)
        }
    }
}

//extension ScannerViewController: AddCardViewControllerDelegate {
//
//     // MARK: - AddingNewCardDelagate
//
//    func userDidEnterData(card: Card) {
//        delegate?.userDidEnterCard(card)
//    }
//}
