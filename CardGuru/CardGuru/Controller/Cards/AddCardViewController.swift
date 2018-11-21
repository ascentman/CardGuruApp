//
//  AddCardViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol AddCardViewControllerDelegate: class {
    func userDidEnterData(card: Card)
}

private enum Parameters {
    static let name = "name"
    static let barcode = "barcode"
}

private enum Constants {
    static let alertTitle = NSLocalizedString("Error", comment: "")
    static let alertMessage = NSLocalizedString("Fill empty fields", comment: "")
    static let acceptTitle = NSLocalizedString("Ok", comment: "")
    static let cards = NSLocalizedString("Cards", comment: "")
}

final class AddCardViewController: UIViewController {

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var barcodeField: UITextField!
    private var name = String()
    private var barcode = String()
    weak var delegate: AddCardViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = name
        barcodeField.text = barcode
        setupCustomBackItem()
        nameField.delegate = self
        barcodeField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction private func saveClicked(_ sender: Any) {
        let name = self.nameField.text
        let barcode = self.barcodeField.text
        if isEnteredDataValid() {
            saveToDbAndNotify(name: name!, barcode: barcode!)
            navigateToRoot()
        } else {
            presentAlert(Constants.alertTitle, message: Constants.alertMessage, acceptTitle: Constants.acceptTitle, declineTitle: nil)
        }
    }
    
    func setBarcode(from: String) {
        barcode = from
    }
    
    // MARK: - Private
    
    private func isEnteredDataValid() -> Bool {
        if nameField.text?.isEmpty ?? true || barcodeField.text?.isEmpty ?? true {
            return false
        }
        return true
    }
    
    private func saveToDbAndNotify(name: String, barcode: String) {
        let parameters = [ Parameters.name : name,
                           Parameters.barcode : barcode]
        let cardId = DatabaseService.shared.saveCard(with: parameters)
        delegate?.userDidEnterData(card: Card(uid: cardId, name: name, barcode: barcode, image: UIImage(named: "shop") ?? UIImage()))
    }
    
    private func navigateToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupCustomBackItem() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: Constants.cards, style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func back() {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Extensions

extension AddCardViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        barcodeField.resignFirstResponder()
        return true
    }
}

private extension String {
    
    // MARK: - Replace dots on underscores
    
    func withReplacedDots() -> String {
        return replacingOccurrences(of: ".", with: "_")
    }
}

