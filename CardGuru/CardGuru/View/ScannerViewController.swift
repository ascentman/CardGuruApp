//
//  ScannerViewController.swift
//  CardGuru
//
//  Created by Vova on 10/17/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {
    private var cardLayer: CALayer?
    private var checkLayer: CALayer?
    private var squareLayer: CALayer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ScannerService.shared.setupSession()
        if let videoLayer = ScannerService.shared.setupVideoLayer() {
            videoLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoLayer)
        }
        setupLayers()
        ScannerService.shared.session?.startRunning()
        ScannerService.shared.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // Private
    
    private func setupLayers() {
        let layers = Layers()
        let squareLayer = layers.setSquareLayer(for: view)
        view.layer.addSublayer(squareLayer)
        let backLayer = layers.setBackLayer(for: view)
        view.layer.addSublayer(backLayer)
        let phoneLayer = layers.setPhoneLayer(for: view)
        view.layer.addSublayer(phoneLayer)
        cardLayer = layers.setCardLayer(for: view)
        if let cardLayer = cardLayer {
            view.layer.addSublayer(cardLayer)
            let animations = Animations()
            let cardAnimation = animations.setCardAnimation(on: cardLayer)
            cardAnimation.delegate = self
            cardLayer.add(cardAnimation, forKey: "position")
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddingNewCard,
            let barcode = sender as? String {
            destination.setBarcode(from: barcode)
        }
    }
}

// Extensions

extension ScannerViewController: ScannerServiceDelegate {
    
    // MARK: ScannerServiceDelegate
    
    func get(barcode: String) {
        performSegue(withIdentifier: "AddNewCard", sender: barcode)
    }
    func changeSquareColor() {
        self.squareLayer?.borderColor = UIColor.green.cgColor
    }
}

extension ScannerViewController: CAAnimationDelegate {
 
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("END!!!!!!!!")
        
        let layers = Layers()
        let animations = Animations()
        checkLayer = layers.setCheckLayer(for: view)
        if let checkLayer = checkLayer {
            view.layer.addSublayer(checkLayer)
            let checkAnimation = animations.setCheckAnimation(on: checkLayer)
            checkLayer.add(checkAnimation, forKey: "opacity")
        }
    }
}
