//
//  MainTabBarVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/23/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item), index == 0, selectedIndex == 0 {
            NotificationCenter.default.post(Notification.scheduleTabTapped)
        }
    }

}
