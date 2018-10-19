//
//  ScannerViewController.swift
//  CardGuru
//
//  Created by Vova on 10/17/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol ScannerViewControllerDelegate: class {

    func userDidEnterCard(_ card: Card)
}

final class ScannerViewController: UIViewController {

    @IBOutlet weak var userView: UIView!
    private var cardLayer: CALayer?
    private var squareLayer: CALayer?

    weak var delegate: ScannerViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScannerService.shared.setupSession()
        if let videoLayer = ScannerService.shared.setupVideoLayer() {
            videoLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoLayer)
        }
        setupLayers()
        ScannerService.shared.session?.startRunning()
        ScannerService.shared.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.userView.isHidden = false
            self.userView.tintColor = UIColor.orange
            self.view.bringSubviewToFront(self.userView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func enterClicked(_ sender: Any) {
        performSegue(withIdentifier: "AddNewCard", sender: nil)
    }
    
    // Private
    
    private func setupLayers() {
        let layers = Layers()
        layers.setSquareLayer(for: view)
        layers.setBackLayer(for: view)
        layers.setPhoneLayer(for: view)
        cardLayer = layers.setCardLayer(for: view)
        if let cardLayer = cardLayer {
            setCardAnimation(on: cardLayer)
        }
    }
    
    private func setCardAnimation(on layer: CALayer) {
        view.layer.addSublayer(layer)
        let animations = Animations()
        let cardAnimation = animations.setCardAnimation(on: layer)
        cardAnimation.delegate = self
        layer.add(cardAnimation, forKey: "position")
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? AddingNewCard)?.delegate = self
        if let destination = segue.destination as? AddingNewCard,
            let barcode = sender as? String {
            destination.setBarcode(from: barcode)
            destination.delegate = self
        }
    }
}

// Extensions

extension ScannerViewController: ScannerServiceDelegate {
    
    // MARK: - ScannerServiceDelegate
    
    func get(barcode: String) {
        performSegue(withIdentifier: "AddNewCard", sender: barcode)
    }
    func changeSquareColor() {
        self.squareLayer?.borderColor = UIColor.green.cgColor
    }
}

extension ScannerViewController: CAAnimationDelegate {
    
    // MARK: - CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        cardLayer?.removeAnimation(forKey: "position")

        let layers = Layers()
        let animations = Animations()
        let checkLayer = layers.setCheckLayer(for: view)
        view.layer.addSublayer(checkLayer)
        let checkAnimation = animations.setCheckAnimation(on: checkLayer)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            checkLayer.removeFromSuperlayer()
        }
        checkLayer.add(checkAnimation, forKey: "opacity")
        CATransaction.commit()
        if let cardLayer = cardLayer {
            setCardAnimation(on: cardLayer)
        }
    }
}

extension ScannerViewController: AddingNewCardDelagate {

     // MARK: - AddingNewCardDelagate
    
    func userDidEnterData(card: Card) {
        delegate?.userDidEnterCard(card)
    }
}
