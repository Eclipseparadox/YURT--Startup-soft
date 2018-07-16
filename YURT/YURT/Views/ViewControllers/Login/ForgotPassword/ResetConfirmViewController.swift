//
//  ResetConfirmViewController.swift
//  YURT
//
//  Created by Standret on 16.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ResetConfirmViewController: SttViewController<SttEmptyPresenter> {

    @IBAction func onBack(_ sender: Any) {
        self.loadStoryboard(storyboard: Storyboard.login)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style = .lightContent
    }
}
