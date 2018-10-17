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
        if let cell = sender as? CardCollectionViewCell,
            let index = cardsCollectionView.indexPath(for: cell) {
            if let destination = segue.destination as? DetailedViewController {
                destination.setDetailedCard(name: cards[index.row].name,
                                            barcode: cards[index.row].barcode,
                                            customerNum: cards[index.row].customerNumber)
            }
        }
        if let destination = segue.destination as? AddingNewCard {
            destination.delegate = self
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
    
    // MARK: - HomeViewController - dataSource & delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // краще шоб cell мав метод який його буде налаштовувавти - у випадк з асинхронним реквестом не дуже підходить так тому краще мати окремо модель на цел - обговорювали
        // в даному випадку ця логіка для завантадження малюнки дуже погана
        // 1- вона не робить так як ти хочеш - додай 100 карток і поскроль - побачиш результат
        // 2 - вона блочить головний потік бо UIImage(withContentsOfUrl: url!) виконується синхронно - нашо Alamofire тоді?
        
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

extension HomeViewController: SendCardDelagate {
    
    // MARK: - HomeViewController - SendCardDelagate
    
    func userDidEnterData(card: Card) {
        cards.append(card)
        self.cardsCollectionView.reloadData()
    }
}
