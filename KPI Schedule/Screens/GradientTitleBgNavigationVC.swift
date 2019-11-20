//
//  GradientTitleBgNavigationVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/11/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class GradientTitleBgNavigationVC: LightStatusBarNavigationVC {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor(patternImage: UIImage(named: "navBarGradient")!.resized(to: navigationBar.bounds.width, and: navigationBar.bounds.width * 0.5)!)
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "navBarGradient")!.resized(to: navigationBar.bounds.width, and: navigationBar.bounds.width * 0.5)!)
        }
    }
    
}
