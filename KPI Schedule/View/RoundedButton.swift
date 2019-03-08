//
//  RoundedButton.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = (backgroundColor ?? .black).cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.7)
        })
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
        })
        super.touchesEnded(touches, with: event)
    }
    
}
