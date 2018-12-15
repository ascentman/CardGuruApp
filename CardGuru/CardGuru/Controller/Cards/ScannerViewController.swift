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
    static let addCardTitle = NSLocalizedString("Error", comment: "")
    static let addcardMessage = NSLocalizedString("Fill empty fields", comment: "")
    static let acceptOkTitle = NSLocalizedString("Ok", comment: "")
}

protocol ScannerViewControllerDelegate: class {
    func userDidEnterCard(_ card: Card)
}

private enum Parameters {
    static let name = "name"
    static let barcode = "barcode"
}

final class ScannerViewController: UIViewController {
    
    @IBOutlet private weak var animatedView: AnimatedView!
    @IBOutlet private weak var userView: UIView!
    @IBOutlet private weak var sourceIndicatorControl: UISegmentedControl!
    private var manualCardAddingView: ManualCardView?
    weak var delegate: ScannerViewControllerDelegate?
    
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
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
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
    
    // MARK: - Private
    
    private func requestCameraAccess() {
        presentAlert(Constants.alertTitle, message: Constants.alertMessage, acceptTitle: Constants.acceptTitle, declineTitle: Constants.cancelTitle, okActionHandler: {
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }, cancelActionHandler: {
            DispatchQueue.main.async {
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
        manualCardAddingView = ManualCardView()
        guard let cardView = manualCardAddingView else {
            return
        }
        cardView.frame = self.userView.frame
        view.addSubview(cardView)
        manualCardAddingView?.delegate = self
    }
}

// Extensions

extension ScannerViewController: ScannerServiceDelegate {

    // MARK: - ScannerServiceDelegate

    func get(barcode: String) {
        DispatchQueue.main.async {
            self.presentAlertWithTextField("Add card name", message: barcode, acceptTitle: "Ok", declineTitle: nil, inputPlaceholder: "store name",
                okActionHandler: { (name) -> (Void) in
                    if var name = name {
                        if name.isEmpty {
                            name = "Unknown"
                        }
                        self.saveToDbAndNotify(name: name, barcode: barcode)
                        self.navigateToRoot()
                    }
            }, cancelActionHandler: nil)
        }
    }
}

extension ScannerViewController: ManualCardViewDelegate {
    
    // MARK: - ManualCardDelegate
    
    func addNewCard(_ card: Card) {
        let newCard = card
        if !(newCard.name.isEmpty || newCard.barcode.isEmpty) {
            saveToDbAndNotify(name: newCard.name, barcode: newCard.barcode)
            navigateToRoot()
        } else {
            presentAlert(Constants.addCardTitle, message: Constants.addcardMessage, acceptTitle: Constants.acceptOkTitle, declineTitle: nil)
        }
    }
    
    private func saveToDbAndNotify(name: String, barcode: String) {
        let parameters = [ Parameters.name : name,
                           Parameters.barcode : barcode]
        let cardId = DatabaseService.shared.saveCard(with: parameters)
        delegate?.userDidEnterCard(Card(uid: cardId, name: name, barcode: barcode, image: UIImage(named: "shop") ?? UIImage()))
    }
    
    private func navigateToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
