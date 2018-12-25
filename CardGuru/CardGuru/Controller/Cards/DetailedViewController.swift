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

protocol DetailedViewControllerAddNotesDelegate: class {
    func userDidAddNotes(to: Card)
}

private enum Constants {
    static let activityText = NSLocalizedString("I would like to share my card with you:", comment: "")
}

final class DetailedViewController: UITableViewController {

    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var barcodeImageView: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var notesButton: UIButton!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var notesView: UIView!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var saveDetailsButton: UIButton!
    @IBOutlet private weak var sliderPosition: NSLayoutConstraint!
    
    private var uid = String()
    private var name = String()
    private var barcode = String()
    private var image = UIImage()
    private var absoluteURL = String()
    private var notesText = String()
    private var barcodeGenerated: UIImage?
    private let manager = FileHandler()
    weak var deleteDelegate: DetailedViewControllerDeletionDelegate?
    weak var updateDelegate: DetailedViewControllerUpdatingDelegate?
    weak var adddNotesDelegate: DetailedViewControllerAddNotesDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupShortcutItem(name: name, barcode: barcode, image: image)
        setupWidget(name: name, image: image)
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
    
    @IBAction func cardClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.sliderPosition.constant = 0
        }
        self.setView(view: self.cardView, hidden: false)
        self.setView(view: self.notesView, hidden: true)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func notesClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.sliderPosition.constant = self.notesButton.center.x - self.view.frame.width / 4
            self.setView(view: self.notesView, hidden: false)
            self.setView(view: self.cardView, hidden: true)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func saveNotesClicked(_ sender: Any) {
        view.endEditing(true)
        notesText = notesTextView.text
        let updatedCard = Card(uid: uid, name: name, barcode: barcode, image: image)
        updatedCard.notesText = notesText
        adddNotesDelegate?.userDidAddNotes(to: updatedCard)
        DatabaseService.shared.addNotesToDb(forCard: updatedCard)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditCardTableViewController {
            destination.getCardBeforeChangeWith(uid: uid, name: name, barcode: barcode, image: image, absoluteURL: absoluteURL)
            destination.updateDelegate = self
            destination.deleteDelegate = self
        }
    }
    
    func setDetailedCard(uid: String, name: String, barcode: String, image: UIImage, absoluteURL: String, notes: String?) {
        self.uid = uid
        self.name = name
        self.barcode = barcode
        self.image = image
        self.absoluteURL = absoluteURL
        self.barcodeGenerated = BarcodeGenerator.generateBarcode(from: barcode)
        if let notes = notes {
            self.notesText = notes
        }
    }
    
    // MARK: - Private
    
    private func setupOutlets() {
        setupBackItem(with: "")
        nameLabel.text = name
        barcodeLabel.text = barcode
        barcodeImageView.image = barcodeGenerated
        imageView.image = image
        notesTextView.text = notesText
        Effects.addShadow(for: shareButton)
        Effects.addShadow(for: saveDetailsButton)
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.orange.cgColor
        notesTextView.delegate = self
    }
    
    private func setupShortcutItem(name: String, barcode: String, image: UIImage) {
        let shortcutType = "work.CardGuru.openLast"
        let shortcutTitle = name.capitalized
        let shortcutItem = UIApplicationShortcutItem(type: shortcutType, localizedTitle: shortcutTitle, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .taskCompleted), userInfo: nil)
        UIApplication.shared.shortcutItems = [shortcutItem]
        saveLastCardToFile()
    }
    
    private func setupWidget(name: String, image: UIImage) {
        UserDefaults.init(suiteName: "group.com.cardGuruApp")?.set(name, forKey: "name")
        if let imageData = image.pngData() {
            UserDefaults.init(suiteName: "group.com.cardGuruApp")?.set(imageData, forKey: "imageData")
        }
    }
    
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1.0, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
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

extension DetailedViewController: UITextViewDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
