//
//  PreferencesTableViewController.swift
//  CardGuru
//
//  Created by Vova on 11/8/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class PreferencesTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (2,0):
            let safari = SafariView()
            safari.openSafari(withAbsoluteURL: "https://apple.com") { viewController in
                present(viewController, animated: true)
            }
        default:
            break
        }
    }
}
