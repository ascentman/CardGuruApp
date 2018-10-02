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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    private var cards: [Card] = []
    
//    var name: String?
//    var email: String?
//    var imageURL: URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseService.shared.cardsRef.observe(DataEventType.value) { (snapshot) in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CardCollectionViewCell,
            let index = cardsCollectionView.indexPath(for: cell) {
            if let destination = segue.destination as? DetailedViewController {
                destination.barcode = cards[index.row].barcode
                destination.customerNum = cards[index.row].customerNumber
                let url = URL(string: cards[index.row].image!)
                destination.image = try! UIImage(withContentsOfUrl: url!)
            }
        }
    }
}

//MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCollectionViewCell {
            if let imagePath = cards[indexPath.row].image {
                let url = URL(string: imagePath)
                let image = try? UIImage(withContentsOfUrl: url!)
                cell.setCellImage(from: image!!)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension UIImage {
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}

