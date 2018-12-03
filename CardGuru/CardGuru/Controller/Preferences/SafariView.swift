//
//  SafariView.swift
//  CardGuru
//
//  Created by Vova on 11/8/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import Foundation
import SafariServices

final class SafariView {
    
    private var safariController: SFSafariViewController?
    
    func openSafari(withAbsoluteURL: String, completion: (UIViewController)->()) {
        if let url = URL(string: withAbsoluteURL) {
            safariController = SFSafariViewController(url: url)
            safariController?.preferredBarTintColor = UIColor.groupTableViewBackground
            safariController?.preferredControlTintColor = UIColor(red: 239/255, green: 56/255, blue: 82/255, alpha: 1.0)
            if let safariController = safariController {
                completion(safariController)
            }
        }
    }
}
