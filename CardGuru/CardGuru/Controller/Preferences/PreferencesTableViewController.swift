//
//  PreferencesTableViewController.swift
//  CardGuru
//
//  Created by Vova on 11/8/18.
//  Copyright © 2018 Vova. All rights reserved.
//

import UIKit

final class PreferencesTableViewController: UITableViewController {
    
    @IBOutlet private weak var touchIdSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        touchIdSwitch.isOn = UserDefaults().isTouchIDEnabled
    }
    
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
    @IBAction private func touchIdSwitched(_ sender: Any) {
        if touchIdSwitch.isOn {
            UserDefaults().saveTouchIdStatus(current: true)
        } else {
            UserDefaults().saveTouchIdStatus(current: false)
        }
    }
}
