//
//  ProposeAddCardView.swift
//  CardGuru
//
//  Created by Vova on 12/7/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol ProposeAddCardViewDelegate: class {
    func loadScannerViewController()
}

final class ProposeAddCardView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var animatedView: UIView!
    @IBOutlet private weak var addButton: UIButton!
    weak var delegate: ProposeAddCardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed("ProposeAddCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        Effects.addShadow(for: addButton)
        LottieImages.setupCardsAnimation(on: animatedView)
    }
    
    @IBAction private func addButtonClicked(_ sender: Any) {
        delegate?.loadScannerViewController()
    }
}
