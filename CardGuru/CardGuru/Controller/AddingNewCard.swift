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
    
     var name: String = ""
     var barcode: String = ""
     var customerNum: String = ""
    
    weak var delegate: AddingNewCardDelagate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.text = name
        self.barcodeField.text = barcode
        setupCustomBackItem()
        nameField.delegate = self

    }
    
    @IBAction private func saveClicked(_ sender: Any) {
        
        let userEmail = UserDefaults().email
        if let userEmail = userEmail {
            let userRef = userEmail.replacingOccurrences(of: ".", with: "_")
            let name = self.nameField.text
            let barcode = self.barcodeField.text
            self.delegate?.userDidEnterData(card: Card(name!, barcode: barcode!))
            
            let parameters = [ "name" : name,
                               "barcode" : barcode]
            DatabaseService.shared.usersRef.child(userRef).child("Cards").childByAutoId().setValue(parameters)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    // needed to hide keyboard when clicked anywhere on a view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        self.view.endEditing(true)
        return true
    }
}