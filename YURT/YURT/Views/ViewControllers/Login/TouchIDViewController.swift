//
//  TouchIDViewController.swift
//  YURT
//
//  Created by Standret on 10.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class TouchIDViewController: SttViewController<TouchIDPresenter> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickYes(_ sender: Any) {
        self.presenter.clickYes()
    }
    @IBAction func clickNo(_ sender: Any) {
        presenter.clickNo()
    }
}
