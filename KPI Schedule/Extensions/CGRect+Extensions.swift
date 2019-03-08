//
//  CGRect+Extensions.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    func shifted(by rect: CGPoint) -> CGRect {
        return CGRect(origin: CGPoint(x: self.origin.x + rect.x, y: self.origin.y + rect.y), size: self.size)
    }
    
    func unshifted(by rect: CGPoint) -> CGRect {
        let rect = CGPoint(x: -rect.x, y: -rect.y)
        return self.shifted(by: rect)
    }
    
}
