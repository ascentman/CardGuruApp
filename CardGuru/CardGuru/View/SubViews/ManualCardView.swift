//
//  ManualCard.swift
//  CardGuru
//
//  Created by Vova on 12/13/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol ManualCardViewDelegate: class {
    func addNewCard(_ card: Card)
}

class ManualCardView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    weak var delegate: ManualCardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed("ManualCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        Effects.addShadow(for: contentView)
        nameTextField.tintColor = UIColor.orange
        barcodeTextField.tintColor = UIColor.orange
        nameTextField.delegate = self
        barcodeTextField.delegate = self
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        print("Saved")
        let name = self.nameTextField.text
        let barcode = self.barcodeTextField.text
        let newCard = Card(uid: "", name: name!, barcode: barcode!, image: UIImage(named: "shop") ?? UIImage())
        delegate?.addNewCard(newCard)
    }
}

// MARK: - Extensions

extension ManualCardView: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        barcodeTextField.resignFirstResponder()
        return true
    }
}
