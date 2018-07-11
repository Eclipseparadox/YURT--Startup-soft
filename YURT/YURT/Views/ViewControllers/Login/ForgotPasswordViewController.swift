//
//  ForgotPasswordViewController.swift
//  YURT
//
//  Created by Standret on 11.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: SttViewController<ForgotPasswordPresenter>, ForgotPasswordDelegate {

    @IBOutlet weak var cnstrHeight: NSLayoutConstraint!
    
    @IBAction func onResetPassword(_ sender: Any) {
        self.navigate(to: "forpasss2", withParametr: nil, callback: { _ in self.close(animated: true) })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        style = .lightContent
        cnstrHeight.constant = heightScreen - 64
    }
}
