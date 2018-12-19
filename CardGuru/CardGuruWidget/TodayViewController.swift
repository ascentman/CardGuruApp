//
//  TodayViewController.swift
//  CardGuruWidget
//
//  Created by Vova on 12/19/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit
import NotificationCenter

private enum Constants {
    static let groupName = "group.com.cardGuruApp"
    static let mainURL = "cardguru://main"
    static let nameKey = "name"
    static let imageDataKey = "imageData"
}

final class TodayViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let name = UserDefaults.init(suiteName: Constants.groupName)?.value(forKey: Constants.nameKey) {
            nameLabel.text = name as? String
        }
        
        if let imageData = UserDefaults.init(suiteName: Constants.groupName)?.value(forKey: Constants.imageDataKey) {
            imageView.image = UIImage(data: imageData as! Data)
        }
    }
    
    @IBAction func cardImageClicked(_ sender: Any) {
        extensionContext?.open(URL(fileURLWithPath: Constants.mainURL), completionHandler: nil)
    }
}

// MARK: - Extensions

extension TodayViewController: NCWidgetProviding {
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}
