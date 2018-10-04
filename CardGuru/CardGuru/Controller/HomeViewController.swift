//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage
import SVProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    private var cards: [Card] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDb()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CardCollectionViewCell,
            let index = cardsCollectionView.indexPath(for: cell) {
            if let destination = segue.destination as? DetailedViewController {
                destination.barcode = cards[index.row].barcode
                destination.customerNum = cards[index.row].customerNumber
                
//                let url = URL(string: cards[index.row].image!)
//                destination.image = try! UIImage(withContentsOfUrl: url!)
                
                    if let image = self.cards[index.row].image,
                        let url = URL(string: image) {
                        Alamofire.request(url, method: .get).responseImage { (response) in

                            print(response.response)
                            debugPrint(response.result)

                            if let image = response.result.value {
                                destination.image = image
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Private
    
    private func loadDataFromDb() {
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
    
    func retrieveImage(for url: String, completion: @escaping (UIImage) -> Void) -> Request {
        return Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else { return }
            completion(image)
        }
    }
}

//MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension UIImage {
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}
