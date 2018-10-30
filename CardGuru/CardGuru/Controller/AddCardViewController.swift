//
//  AddCardViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Parameters {
    static let name = "name"
    static let barcode = "barcode"
}

protocol AddCardViewControllerDelegate: class {
    func userDidEnterData(card: Card)
}

final class AddCardViewController: UIViewController {

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var barcodeField: UITextField!
    private var name = String()
    private var barcode = String()
    weak var delegate: AddCardViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.text = name
        self.barcodeField.text = barcode
        setupCustomBackItem()
        nameField.delegate = self
        barcodeField.delegate = self
    }
    
    @IBAction private func saveClicked(_ sender: Any) {
        let name = self.nameField.text
        let barcode = self.barcodeField.text
        guard let nameCard = name,
            let barcodeCard = barcode else {
            return
        }
        let parameters = [ Parameters.name : name,
                           Parameters.barcode : barcode]
        let cardId = DatabaseService.shared.saveCard(with: parameters as [String : Any])
        print("UID saveClicked", cardId)
        delegate?.userDidEnterData(card: Card(uid: cardId, name: nameCard, barcode: barcodeCard))
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setBarcode(from: String) {
        barcode = from
    }
    
    private func setupCustomBackItem() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cards", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func back() {
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

extension String {
    
    // MARK: - Replace dots on underscores
    
    func withReplacedDots() -> String {
        return replacingOccurrences(of: ".", with: "_")
    }
}
