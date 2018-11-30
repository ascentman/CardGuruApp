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
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        touchIdSwitch.isOn = UserDefaults().isTouchIDEnabled
        notificationsSwitch.isOn = UserDefaults().isNotificationsTurnedOn
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
    @IBAction func notificationSwitched(_ sender: Any) {
        if notificationsSwitch.isOn {
            LocalNotificationsService.shared.registerLocalNotifications()
            UserDefaults().saveNotificationStatus(current: true)
            LocalNotificationsService.shared.sendNotification()
        } else {
             UserDefaults().saveNotificationStatus(current: false)
        }
    }
}
