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

    @IBOutlet weak var nameView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var barcodeTextField: UITextField!
    
    weak var deleteDelegate: EditCardTableViewControllerDeletionDelegate?
    weak var updateDelegate: EditCardTableViewControllerUpdatingDelegate?
    private var uid = String()
    private var name = String()
    private var barcode = String()
    private let tableHeaderHeight: CGFloat = 70.0
    
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
        nameLabel.text = name
        nameTextField.text = name
        barcodeTextField.text = barcode
        nameTextField.delegate = self
        barcodeTextField.delegate = self
        createStickyView()
        
        tableView.tableFooterView = UIView()
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
        if let name = nameTextField.text,
            let barcode = barcodeTextField.text {
            let updatedCard = Card(uid: uid, name: name, barcode: barcode)
            updateDelegate?.userDidUpdateData(with: updatedCard)
            DatabaseService.shared.updateDataInDb(forCard: updatedCard)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteCard(_ sender: Any) {
        DatabaseService.shared.removeDataFromDb(withUID: uid)
        deleteDelegate?.userDidRemoveData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getCardBeforeChangeWith(uid: String, name: String, barcode: String) {
        self.uid = uid
        self.name = name
        self.barcode = barcode
    }
    
    // MARK: - Private
    
    private func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        nameView.frame = headerRect
    }
    
    private func createStickyView() {
        nameView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(nameView)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
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
