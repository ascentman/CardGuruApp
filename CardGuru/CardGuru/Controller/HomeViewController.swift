//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var cardsCollectionView: UICollectionView!
    private var cards: [Card] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LottieView.setupBackgroundGradient(on: view)
        DatabaseService.shared.loadDataFromDb { (cards) in
            self.cards = cards
            self.cardsCollectionView.reloadData()
        }
    }

    private func loadCardImages() {
        for (index, card) in cards.enumerated() where card.absoluteURL != nil {
            Downloader.shared.loadImage(card.absoluteURL) { image in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.cardsCollectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
                cell?.setCell(name: card.name, image: image ?? UIImage(named: "shop") ?? UIImage())
                self.cards[index].image = image
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ScannerViewController {
            destination.delegate = self
        }
        if let cell = sender as? CardCollectionViewCell,
            let index = cardsCollectionView.indexPath(for: cell) {
            if let destination = segue.destination as? DetailedViewController {
                destination.setDetailedCard(uid: cards[index.row].uid,
                                            name: cards[index.row].name,
                                            barcode: cards[index.row].barcode,
                                            image: cards[index.row].image ?? UIImage(named: "shop") ?? UIImage(),
                                            absoluteURL: cards[index.row].absoluteURL ?? String())
                destination.updateDelegate = self
                destination.deleteDelegate = self
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
            let card = cards[indexPath.row]
            cell.setCell(name: card.name, image: card.image ?? UIImage(named: "shop") ?? UIImage())
            loadCardImages()
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

extension HomeViewController: DetailedViewControllerDeletionDelegate {
    
    // MARK: - DetailedViewControllerDeletionDelegate

    func userDidRemoveData() {
        DatabaseService.shared.loadDataFromDb { (cards) in
            self.cards = cards
            self.cardsCollectionView.reloadData()
        }
    }
}

extension HomeViewController: DetailedViewControllerUpdatingDelegate {
    
    // MARK: - DetailedViewControllerUpdatingDelegate

    func userDidUpdateData(with: Card) {
        for card in cards {
            if card.uid == with.uid {
                card.name = with.name
                card.barcode = with.barcode
                card.image = with.image
            }
        }
        self.cardsCollectionView.reloadData()
    }
}

