//
//  ViewController.swift
//  CardGuru
//
//  Created by Vova on 9/24/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Constants {
    static let searchTitle = NSLocalizedString("Search card", comment: "")
}

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var cardsCollectionView: UICollectionView!
    private var cardPlaceholderView: ProposeAddCardView?
    private let searchController = UISearchController(searchResultsController: nil)
    private var cards: [Card]?
    private var filteredCards: [Card] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        DatabaseService.shared.loadDataFromDb { (cards) in
            DispatchQueue.main.async {
            self.cards = cards
            if cards.count == 0 {
                self.addCardPlaceholderView(on: self.view)
            } else {
                self.cardsCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if cards != nil {
            checkIfPlaceholderViewNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults().isForceTouchActive {
            DispatchQueue.main.async {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
        UserDefaults().saveForceTouchActive(current: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.searchBar.isHidden = false
    }

    private func loadCardImages(to cards: [Card]) {
        for (index, card) in cards.enumerated() where card.absoluteURL != nil {
            Downloader.shared.loadImage(card.absoluteURL) { image in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = self.cardsCollectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
                cards[index].image = image
                cell?.setCell(name: card.name, image: image ?? UIImage(named: "shop") ?? UIImage())
            }
        }
    }
    
    private func loadCardsIfOffline(_ cell: CardCollectionViewCell, _ card: Card) {
        if !Connectivity.isConnectedToInternet {
            cell.setCell(name: card.name, image: UIImage(named: "shop") ?? UIImage())
        }
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        searchController.searchBar.tintColor = UIColor.orange
        searchController.searchBar.placeholder = Constants.searchTitle
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    private func filterCardsForSearchedText(_ searchText: String) {
        if let cards = cards {
            filteredCards = cards.filter( {(card: Card) -> Bool in
                return card.name.lowercased().starts(with: searchText.lowercased())
            })
            cardsCollectionView.reloadData()
        }
    }
    
    private func addCardPlaceholderView(on view: UIView) {
        cardPlaceholderView = ProposeAddCardView()
        guard let cardPlaceholderView = cardPlaceholderView else {
            return
        }
        cardPlaceholderView.frame = self.view.frame
        cardPlaceholderView.delegate = self
        view.addSubview(cardPlaceholderView)
    }
    
    private func checkIfPlaceholderViewNeeded() {
        if cards?.count == 0 {
            if let cardPlaceholderView = cardPlaceholderView {
                if !view.subviews.contains(cardPlaceholderView) {
                    addCardPlaceholderView(on: view)
                }
            } else {
                addCardPlaceholderView(on: view)
            }
        } else {
            if let cardPlaceholderView = cardPlaceholderView {
                if view.subviews.contains(cardPlaceholderView) {
                    cardPlaceholderView.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cards = cards else {
            return
        }
        if let destination = segue.destination as? ScannerViewController {
            destination.delegate = self
        }
        if let cell = sender as? CardCollectionViewCell,
            let index = cardsCollectionView.indexPath(for: cell) {
            if let destination = segue.destination as? DetailedViewController {
                if searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) {
                    destination.setDetailedCard(uid: filteredCards[index.row].uid,
                                                name: filteredCards[index.row].name,
                                                barcode: filteredCards[index.row].barcode,
                                                image: filteredCards[index.row].image ?? UIImage(named: "shop") ?? UIImage(),
                                                absoluteURL: filteredCards[index.row].absoluteURL ?? String())
                } else {
                    destination.setDetailedCard(uid: cards[index.row].uid,
                                                name: cards[index.row].name,
                                                barcode: cards[index.row].barcode,
                                                image: cards[index.row].image ?? UIImage(named: "shop") ?? UIImage(),
                                                absoluteURL: cards[index.row].absoluteURL ?? String())
                }
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
        guard let cards = cards else {
            return 0
        }
        if searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) {
            return filteredCards.count
        }
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cards = cards else {
            return UICollectionViewCell()
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCollectionViewCell {
            if searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) {
                let card = filteredCards[indexPath.row]
                loadCardImages(to: filteredCards)
                loadCardsIfOffline(cell, card)
                cell.setCell(name: card.name, image: card.image ?? UIImage(named: "shop") ?? UIImage())
            } else {
                let card = cards[indexPath.row]
                loadCardImages(to: cards)
                loadCardsIfOffline(cell, card)
                cell.setCell(name: card.name, image: card.image ?? UIImage(named: "shop") ?? UIImage())
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
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
        cards?.append(card)
        self.cardsCollectionView.reloadData()
    }
}

extension HomeViewController: DetailedViewControllerDeletionDelegate {
    
    // MARK: - DetailedViewControllerDeletionDelegate
    
    func userDidRemoveData() {
        DatabaseService.shared.loadDataFromDb { (cards) in
            self.cards = cards
            self.checkIfPlaceholderViewNeeded()
            self.cardsCollectionView.reloadData()
        }
    }
}

extension HomeViewController: DetailedViewControllerUpdatingDelegate {
    
    // MARK: - DetailedViewControllerUpdatingDelegate

    func userDidUpdateData(with: Card) {
        guard let cards = cards else {
            return
        }
        for card in cards {
            if card.uid == with.uid {
                card.name = with.name
                card.barcode = with.barcode
                card.image = with.image
                card.absoluteURL = nil
            }
        }
        self.cardsCollectionView.reloadData()
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        if let term = searchController.searchBar.text {
            filterCardsForSearchedText(term)
        }
    }
}

extension HomeViewController: ProposeAddCardViewDelegate {
    
    // MARK: - DetailedViewControllerDeletionDelegate
    
    func loadScannerViewController() {
        performSegue(withIdentifier: "AddCard", sender: nil)
    }
}
