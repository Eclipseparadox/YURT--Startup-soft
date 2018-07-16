//
//  SuccessViewController.swift
//  YURT
//
//  Created by Standret on 13.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import Lottie

class SuccessViewController: SttViewController<ShowPresenter> {

    @IBOutlet weak var vSuccess: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblWithAtribute: UILabel!
    
    private var animationView = LOTAnimationView(name: "check")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = 5
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
        //self.dismiss(animated: true, completion: nil)
        animationView.frame = CGRect(x: 0, y: 0, width: 29, height: 29)
        vSuccess.addSubview(animationView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func onTap(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}
