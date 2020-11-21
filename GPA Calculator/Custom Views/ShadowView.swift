//
//  ShadowView.swift
//  GPA Calculator
//
//  Created by Pranav Ramesh on 11/19/20.
//  Copyright © 2020 Pranav Ramesh. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    let kCornerRadius: CGFloat = 12
    
    override func layoutSubviews() {
        layer.cornerRadius = kCornerRadius
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.23
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: kCornerRadius).cgPath
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: kCornerRadius).cgPath
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: kCornerRadius).cgPath
    }
}
