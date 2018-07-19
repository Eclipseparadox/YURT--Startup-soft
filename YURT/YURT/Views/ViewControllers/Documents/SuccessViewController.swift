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
        animationView.frame = CGRect(x: -20, y: -20, width: 69, height: 69)
        vSuccess.addSubview(animationView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    @objc private func onTap(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
}
