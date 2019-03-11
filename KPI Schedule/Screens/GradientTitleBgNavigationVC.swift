//
//  GradientTitleBgNavigationVC.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/11/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

class GradientTitleBgNavigationVC: LightStatusBarNavigationVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "navBarGradient")!)
    }
    
}
