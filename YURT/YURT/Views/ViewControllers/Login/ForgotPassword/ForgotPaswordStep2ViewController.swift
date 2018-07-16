//
//  ForgotPaswordStep2ViewController.swift
//  YURT
//
//  Created by Standret on 11.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class ForgotPaswordStep2ViewController: SttViewController<SttEmptyPresenter> {

    @IBOutlet weak var cntrHeight: NSLayoutConstraint!
    
    @IBAction func closeClick(_ sender: Any) {
        close(parametr: true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        style = .lightContent
        cntrHeight.constant = heightScreen
    }
}

