//
//  AddingNewCard.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol AddingNewCardDelagate: class {
    func userDidEnterData(card: Card)
}

final class AddingNewCard: UIViewController {

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var barcodeField: UITextField!
    private var name = String()
    private var barcode = String()
    weak var delegate: AddingNewCardDelagate?
    
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
        let userEmail = UserDefaults().email
        if let userEmail = userEmail {
            let userRef = userEmail.withReplacedDots()
            let name = self.nameField.text
            let barcode = self.barcodeField.text
            delegate?.userDidEnterData(card: Card(name!, barcode: barcode!))
            let parameters = [ "name" : name,
                               "barcode" : barcode]
            DatabaseService.shared.saveCard(for: userRef, with: parameters as [String : Any])
        }
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

extension AddingNewCard: UITextFieldDelegate {
    
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

