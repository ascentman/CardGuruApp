//
//  AddingNewCard.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class AddingNewCard: UIViewController {

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var barcodeField: UITextField!
    @IBOutlet private weak var customerNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerNumberField.delegate = self
    }
    
    @IBAction private func saveClicked(_ sender: Any) {
        let name = nameField.text
        let barcode = barcodeField.text
        let customerNumber = customerNumberField.text
        
        if let name = name {
            let image = generateImage(from: name)
            let imageData = try? Data(contentsOf: URL(string: image)!) //force - crash
            DatabaseService.shared.cardImageRef.putData(imageData!) //force - crash
            
            let parameters = [ "name" : name,
                               "barcode" : barcode,
                               "customerNumber": customerNumber,
                               "image" : image]
            DatabaseService.shared.cardsRef.childByAutoId().setValue(parameters)
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //wtf?
        self.view.endEditing(true)
    }
    
    // MARK: - Private

    // extenstion?
    private func generateImage(from name: String) -> String {
        let formattedName = name.replacingOccurrences(of: " ", with: "_")
        let randomColor = UIColor.random
        return "https://dummyimage.com/600x400/\(randomColor)/ffffff.png&text=\(formattedName)"
    }
}

// MARK: - Extensions

extension AddingNewCard: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
