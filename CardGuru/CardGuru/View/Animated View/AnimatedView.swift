//
//  AnimatedView.swift
//  CardGuru
//
//  Created by Vova on 10/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class AnimatedView: UIView {
    
    @IBOutlet private weak var contentContainerView: UIView!
    
    private var backLayer: BackLayer?
    private var squareLayer: SquareLayer?
    private var cardLayer: CardLayer?
    private var phoneLayer: PhoneLayer?
    private var checkLayer: CheckLayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed(String(describing: AnimatedView.self), owner: self, options: nil)
        addSubview(contentContainerView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frame = UIScreen.main.bounds
        
        backLayer = BackLayer(inFrame: frame)
        squareLayer = SquareLayer(inFrame: frame)
        phoneLayer = PhoneLayer(inFrame: frame)
        cardLayer = CardLayer(inFrame: frame)
        checkLayer = CheckLayer(inFrame: frame)
        
        guard let backLayer = backLayer,
            let cardLayer = cardLayer,
            let squareLayer = squareLayer,
            let phoneLayer = phoneLayer,
            let checkLayer = checkLayer else {
                return
        }
        startAnimation()
        
        layer.addSublayer(backLayer)
        layer.addSublayer(squareLayer)
        layer.addSublayer(phoneLayer)
        layer.addSublayer(cardLayer)
        layer.addSublayer(checkLayer)
    }
    
    private func animateCardLayer(_ completion: ((Bool) -> ())?) {
        let toPoint = CGPoint(x: bounds.midX, y: 150)
        let fromPoint = CGPoint(x: bounds.maxX, y: 150)
        cardLayer?.animateLayer(from: fromPoint, to: toPoint) { isFinished in
            completion?(isFinished)
        }
    }
    
    private func animateCheckLayer() {
        checkLayer?.animateLayer(from: 0.0, to: 1.0, with: { [weak self] _ in
            self?.animateCardLayer({ [weak self] _ in
                self?.animateCheckLayer()
            })
        })
    }
    
    private func startAnimation() {
        animateCardLayer { [weak self] _ in
            self?.animateCheckLayer()
        }
    }
}
