//
//  WelcomeViewController.swift
//  YURT
//
//  Created by Standret on 10.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class WelcomeViewController: SttViewController<WelcomePresenter> {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style = .lightContent

        lblLocation.text = presenter.navigateModel.location
        lblName.text = "Welcome, \(presenter.navigateModel.firstName)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.presenter.loadNext()
        }
    }
}
