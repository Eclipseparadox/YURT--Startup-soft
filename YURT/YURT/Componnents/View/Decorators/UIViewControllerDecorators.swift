//
//  UIViewControllerDecorators.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

extension UIViewController {
    func configurationNavigationBar () {
        navigationController?.navigationBar.tintColor = UIColor(named: "TitleNavBarForegoundColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "TitleNavBarBackgroundColor")
        navigationController?.navigationBar.isTranslucent = true
    }
}
