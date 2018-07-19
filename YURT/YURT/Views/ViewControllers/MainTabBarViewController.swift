//
//  MainTabBarViewController.swift
//  YURT
//
//  Created by Standret on 18.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.3
        self.selectedIndex = GlobalVariable.isRegistration ? 1 : 0
        
        _ = AppDelegateEvent.openUrlObservable.subscribe(onNext: { (key) in
            let stroyboard = UIStoryboard(name: Storyboard.login.getName(), bundle: nil)
            let vc = stroyboard.instantiateViewController(withIdentifier: "start")
            self.present(vc, animated: true, completion: nil)
        })
    }
}
