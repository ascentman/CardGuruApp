//
//  AddingNewCard.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol SendCardDelagate: class {
    func userDidEnterData(card: Card)
}

final class AddingNewCard: UIViewController {

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var barcodeField: UITextField!
    @IBOutlet private weak var customerNumberField: UITextField!
    
     var name: String = ""
     var barcode: String = ""
     var customerNum: String = ""
    
    weak var delegate: SendCardDelagate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.text = name
        self.barcodeField.text = barcode
        self.customerNumberField.text = customerNum
        customerNumberField.delegate = self
    }
    
    @IBAction private func saveClicked(_ sender: Any) {
        
        DatabaseService.shared.settingsRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: String],
                let userEmail = dict["email"] else {
                    return
            }
            let userRef = userEmail.replacingOccurrences(of: ".", with: "_")
            let name = self.nameField.text
            let barcode = self.barcodeField.text
            let customerNumber = self.customerNumberField.text
            
            self.delegate?.userDidEnterData(card: Card(name!, barcode: barcode!, customerNumber!))
            
            let parameters = [ "name" : name,
                               "barcode" : barcode,
                               "customerNumber": customerNumber]
            DatabaseService.shared.usersRef.child(userRef).child("Cards").childByAutoId().setValue(parameters)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setBarcode(from: String) {
        barcode = from
    }
}

// MARK: - Extensions

extension AddingNewCard: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
