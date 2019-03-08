//
//  LessonLocationLabel.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

@IBDesignable
class LessonLocationLabel: PaddingLabel {
    
    @IBInspectable var borderColor: UIColor?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.5
        layer.borderColor = borderColor?.cgColor
        font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        textColor = borderColor
    }
    
}
