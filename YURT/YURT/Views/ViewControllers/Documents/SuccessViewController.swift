//
//  SuccessViewController.swift
//  YURT
//
//  Created by Standret on 13.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

class SuccessViewController: SttViewController<ShowPresenter> {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblWithAtribute: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = 5
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
        let timer = Timer(timeInterval: 1.5, repeats: false) { (timer) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func onTap(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}
