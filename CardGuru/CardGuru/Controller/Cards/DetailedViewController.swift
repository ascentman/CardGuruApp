//
//  DetailedViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol DetailedViewControllerDeletionDelegate: class {
    func userDidRemoveData()
}

protocol DetailedViewControllerUpdatingDelegate: class {
    func userDidUpdateData(with: Card)
}

private enum Constants {
    static let activityText = NSLocalizedString("I would like to share my card with you:", comment: "")
}

final class DetailedViewController: UIViewController {

    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var barcodeImageView: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    
    private var uid = String()
    private var name = String()
    private var barcode = String()
    private var image = UIImage()
    private var absoluteURL = String()
    private var barcodeGenerated: UIImage?
    private let manager = FileHandler()
    weak var deleteDelegate: DetailedViewControllerDeletionDelegate?
    weak var updateDelegate: DetailedViewControllerUpdatingDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupBackItem(with: "")
        setupShortcutItem(name: name, barcode: barcode, image: image)
        Effects.addShadow(for: shareButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        let shareViewController = UIActivityViewController(activityItems: ["\(Constants.activityText) \(name), \(barcode)"], applicationActivities: nil)
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditCardTableViewController {
            destination.getCardBeforeChangeWith(uid: uid, name: name, barcode: barcode, image: image, absoluteURL: absoluteURL)
            destination.updateDelegate = self
            destination.deleteDelegate = self
        }
    }
    
    func setDetailedCard(uid: String, name: String, barcode: String, image: UIImage, absoluteURL: String) {
        self.uid = uid
        self.name = name
        self.barcode = barcode
        self.image = image
        self.absoluteURL = absoluteURL
        self.barcodeGenerated = BarcodeGenerator.generateBarcode(from: barcode)
    }
    
    // MARK: - Private
    
    private func setupOutlets() {
        nameLabel.text = name
        barcodeLabel.text = barcode
        barcodeImageView.image = barcodeGenerated
        imageView.image = image
    }
    
    private func setupShortcutItem(name: String, barcode: String, image: UIImage) {
        let shortcutType = "work.CardGuru.openLast"
        let shortcutTitle = name.capitalized
        let shortcutItem = UIApplicationShortcutItem(type: shortcutType, localizedTitle: shortcutTitle, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .taskCompleted), userInfo: nil)
        UIApplication.shared.shortcutItems = [shortcutItem]
        saveLastCardToFile()
    }
    
    private func saveLastCardToFile() {
        try? manager.writeDataToPlist(lastCard: LastCard(name: name.capitalized, barcode: barcode, imageData: image.pngData()))
    }
}

extension DetailedViewController: EditCardTableViewControllerUpdatingDelegate {
    
    // MARK: - EditCardTableViewControllerDelegate
    
    func userDidUpdateData(with: Card) {
        nameLabel.text = with.name
        barcodeLabel.text = with.barcode
        imageView.image = with.image
        self.name = with.name
        self.barcode = with.barcode
        self.image =  with.image ?? UIImage(named: "shop") ?? UIImage()
        updateDelegate?.userDidUpdateData(with: Card(uid: uid, name: with.name, barcode: with.barcode, image: with.image ?? UIImage()))
    }
}

extension DetailedViewController: EditCardTableViewControllerDeletionDelegate {

     // MARK: - EditCardTableViewControllerDelegate

    func userDidRemoveData() {
        deleteDelegate?.userDidRemoveData()
    }
}
