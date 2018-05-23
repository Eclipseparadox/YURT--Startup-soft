//
//  SttComandExtensions.swift
//  YURT
//
//  Created by Standret on 23.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

extension SttComand {
    func useIndicator(button: UIButton) {
        let indicator = button.setIndicator()
        indicator.color = UIColor.white
        let title = button.titleLabel?.text
        self.addHandler(start: {
            button.setTitle("", for: .disabled)
            button.isEnabled = false
            indicator.startAnimating()
        }) {
            button.setTitle(title, for: .disabled)
            button.isEnabled = true
            indicator.stopAnimating()
        }
    }
}
