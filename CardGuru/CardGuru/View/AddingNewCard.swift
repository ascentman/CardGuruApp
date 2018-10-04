//
//  AddingNewCard.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class AddingNewCard: UIViewController {

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var barcodeField: UITextField!
    @IBOutlet private weak var customerNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerNumberField.delegate = self
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let name = nameField.text
        let barcode = barcodeField.text
        let customerNumber = customerNumberField.text
        
        if let name = name {
            let image = generateImage(from: name)
            let imageData = try? Data(contentsOf: URL(string: image)!)
            DatabaseService.shared.cardImageRef.putData(imageData!)
            
            let parameters = [ "name" : name,
                               "barcode" : barcode,
                               "customerNumber": customerNumber,
                               "image" : image]
            DatabaseService.shared.cardsRef.childByAutoId().setValue(parameters)
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Private
    
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

extension UIColor {
    static var random: String {
        let r:CGFloat = .random(in: 0...0.9)
        let g:CGFloat = .random(in: 0...0.9)
        let b:CGFloat = .random(in: 0...0.9)
        
        var color = String(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        color += String(format: "%02lX", lroundf(Float(0.9)))
        return color
    }
}
