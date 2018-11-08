//
//  EditCardViewController.swift
//  CardGuru
//
//  Created by Vova on 10/29/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

protocol EditCardTableViewControllerDeletionDelegate: class {
    func userDidRemoveData()
}

protocol EditCardTableViewControllerUpdatingDelegate: class {
    func userDidUpdateData(with: Card)
}

final class EditCardTableViewController: UITableViewController {

    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changeImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var barcodeTextField: UITextField!
    
    weak var deleteDelegate: EditCardTableViewControllerDeletionDelegate?
    weak var updateDelegate: EditCardTableViewControllerUpdatingDelegate?
    private var uid = String()
    private var name = String()
    private var barcode = String()
    private var image = UIImage()
    private var absoluteURL = String()
    private let pickImage = ImagePickerClass()
    private let tableHeaderHeight: CGFloat = 150.0
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        nameTextField.delegate = self
        barcodeTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func saveCard(_ sender: Any) {
        let updatedName = nameTextField.text
        let updatedBarcode = barcodeTextField.text
        let updatedImage = changeImageView.image
        
        if isEnteredDataValid() {
            if let name = updatedName,
                let barcode = updatedBarcode,
                let image = updatedImage {
                let updatedCard = Card(uid: uid, name: name, barcode: barcode, image: image)
                updateCardInDbAndNotify(image: image, for: updatedCard)
                navigateBack()
            }
        } else {
            presentAlert("Error", message: "Fill empty fields", acceptTitle: "Ok", declineTitle: nil)
        }
    }
    
    @IBAction func deleteCard(_ sender: Any) {
        if !absoluteURL.isEmpty {
            DatabaseService.shared.removeImageFromStorage(withURL: absoluteURL)
        }
        DatabaseService.shared.removeDataFromDb(withUID: uid)
        deleteDelegate?.userDidRemoveData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changeImageClicked(_ sender: Any) {
        ImagePickerClass().pickImage(self) { (image) in
            self.changeImageView.image = image
            self.imageView.image = image
        }
    }
    
    func getCardBeforeChangeWith(uid: String, name: String, barcode: String, image: UIImage, absoluteURL: String) {
        self.uid = uid
        self.name = name
        self.barcode = barcode
        self.image = image
        self.absoluteURL = absoluteURL
    }
    
    // MARK: - Private
    
    private func setupOutlets() {
        nameLabel.text = name
        nameTextField.text = name
        barcodeTextField.text = barcode
        imageView.image = image
        changeImageView.image = image
        createStickyView()
        tableView.tableFooterView = UIView()
    }
    
    private func isEnteredDataValid() -> Bool {
        if nameTextField.text?.isEmpty ?? true || barcodeTextField.text?.isEmpty ?? true {
            return false
        }
        return true
    }
    
    private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        labelView.frame = headerRect
    }
    
    private func createStickyView() {
        labelView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(labelView)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
    }
    
    private func updateCardInDbAndNotify(image: UIImage, for card: Card) {
        let updatedCard = card
        DatabaseService.shared.saveCardImage(image: image) { (url, error) in
            if let url = url {
                updatedCard.absoluteURL = url
                DatabaseService.shared.updateDataInDb(forCard: updatedCard)
            }
        }
        updateDelegate?.userDidUpdateData(with: updatedCard)
    }
}

// MARK: - Extensions

extension EditCardTableViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        barcodeTextField.resignFirstResponder()
        return true
    }
}
