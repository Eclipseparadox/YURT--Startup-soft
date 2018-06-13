//
//  UIView.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func createCircle(dominateWidth: Bool = true, clipToBounds: Bool = true) {
        if dominateWidth {
            layer.cornerRadius = bounds.width / 2
        }
        else {
            layer.cornerRadius = bounds.height / 2
        }
        self.clipsToBounds = clipToBounds
    }
    
    func setBorder(color: UIColor, size: Float) {
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = CGFloat(size)
    }
    
    func setShadow(color: UIColor, opacity: Float = 0.2, radius: Float = 1) {
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = CGFloat(radius)
    }
    
    func setIndicator(style: UIActivityIndicatorViewStyle = .gray, color: UIColor = UIColor.gray) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = style
        indicator.color = color
        
        indicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicator)
        
        
        return indicator
    }
}

