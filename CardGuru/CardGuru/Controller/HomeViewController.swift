//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var cardsCollectionView: UICollectionView!
    private var cards: [Card] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDb()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ScannerViewController {
            destination.delegate = self
        }
        
        if let cell = sender as? CardCollectionViewCell,
            let index = cardsCollectionView.indexPath(for: cell) {
            if let destination = segue.destination as? DetailedViewController {
                destination.setDetailedCard(name: cards[index.row].name,
                                            barcode: cards[index.row].barcode)
            }
        }
    }
    
    // MARK: - Private

    // такі методи які контролюють дані краще винести в окремий файл і ним контролювати шоб контролер відповідав лише за View і зміну View
    private func loadDataFromDb() {
        
        if let userEmail = UserDefaults().email {
            let userRef = userEmail.replacingOccurrences(of: ".", with: "_")
            
            DatabaseService.shared.usersRef.child(userRef).child("Cards").observeSingleEvent(of: .value) { (snapshot) in
                var cards: [Card] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                        let card = Card(snapshot: snapshot) {
                        cards.append(card)
                    }
                }
                self.cards = cards
                self.cardsCollectionView.reloadData()
            }
        }
    }
}

//MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - dataSource & delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCollectionViewCell {
            
            let card = cards[indexPath.row].name
            cell.setCellName(from: card)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension HomeViewController: ScannerViewControllerDelegate {
    
    // MARK: - ScannerViewControllerDelegate

    func userDidEnterCard(_ card: Card) {
        cards.append(card)
        self.cardsCollectionView.reloadData()
    }
}
