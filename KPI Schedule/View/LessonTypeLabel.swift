//
//  LessonTypeLabel.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

@IBDesignable
class LessonTypeLabel: PaddingLabel {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 4.0
        clipsToBounds = true
        font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        textColor = .white
    }
    
}
