//
//  ManualCard.swift
//  CardGuru
//
//  Created by Vova on 12/13/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class ManualCard: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    
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
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        print("Saved")
    }
}
