//
//  UIView.swift
//  MovieApp
//
//  Created by Rasslan on 26/08/2025.
//


import UIKit


extension UIView {
    
    func applyDefaultStyle(
        cornerRadius: CGFloat = 8,
        shadowColor: UIColor = .shadow,
        shadowOpacity: Float = 1,
        shadowOffset: CGSize = .init(width: 0, height: 2),
        shadowRadius: CGFloat = 4
    ) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}


extension UIView {
    
    /// Apply default border styling
    func applyDefaultBorder(
        color: UIColor = .lightGray,
        width: CGFloat = 1
    ) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
