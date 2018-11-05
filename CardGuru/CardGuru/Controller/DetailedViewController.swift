//
//  DetailedViewController.swift
//  CardGuru
//
//  Created by Vova on 10/1/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

private enum Filter {
    static let name = "CICode128BarcodeGenerator"
    static let forKey = "inputMessage"
}

protocol DetailedViewControllerDeletionDelegate: class {
    func userDidRemoveData()
}

protocol DetailedViewControllerUpdatingDelegate: class {
    func userDidUpdateData(with: Card)
}

final class DetailedViewController: UIViewController {

    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    weak var deleteDelegate: DetailedViewControllerDeletionDelegate?
    weak var updateDelegate: DetailedViewControllerUpdatingDelegate?
    private var uid = String()
    private var name = String()
    private var barcode = String()
    private var image = UIImage()
    private var absoluteURL = String()
    private var barcodeGenerated: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        barcodeLabel.text = barcode
        barcodeImageView.image = barcodeGenerated
        imageView.image = image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        let shareViewController = UIActivityViewController(activityItems: ["I would like to share my card with you: \(name), \(barcode)"], applicationActivities: nil)
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
        self.barcodeGenerated = generateBarcode(from: barcode)
    }
    
    private func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: Filter.name) {
            filter.setValue(data, forKey: Filter.forKey)
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
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
