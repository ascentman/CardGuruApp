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

final class HomeViewController: UIViewController { //final
    
    @IBOutlet private weak var cardsCollectionView: UICollectionView!
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

                // говорили -балакали - сіли -заплакати - виправити
                
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

    // такі методи які контролюють дані краще винести в окремий файл і ним контролювати шоб контролер відповідав лише за View і зміну View
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
    
    func retrieveImage(for url: String, completion: @escaping (UIImage) -> Void) -> Request { //private - краще винести в окремий сервіс шо контролює network реквести
        return Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else { return }
            completion(image)
        }
    }
}

//MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // де марки?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // краще шоб cell мав метод який його буде налаштовувавти - у випадк з асинхронним реквестом не дуже підходить так тому краще мати окремо модель на цел - обговорювали
        // в даному випадку ця логіка для завантадження малюнки дуже погана
        // 1- вона не робить так як ти хочеш - додай 100 карток і поскроль - побачиш результат
        // 2 - вона блочить головний потік бо UIImage(withContentsOfUrl: url!) виконується синхронно - нашо Alamofire тоді?

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCollectionViewCell {
            if let imagePath = cards[indexPath.row].image {
                let url = URL(string: imagePath)
                let image = try? UIImage(withContentsOfUrl: url!)//force - crash
                cell.setCellImage(from: image!!)//force - crash
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

// знову теж саме - чому не в окремому файлі? шо це таке 
extension UIImage {
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}
