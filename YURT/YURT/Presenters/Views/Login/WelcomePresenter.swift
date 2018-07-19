//
//  WelcomePresenter.swift
//  YURT
//
//  Created by Standret on 10.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct WelcomNavigateModel {
    let firstName: String
    let location: String
    let email: String
    let password: String
}

class WelcomePresenter: SttPresenter<SttViewContolable> {
    
    var navigateModel: WelcomNavigateModel!
    
    override func prepare(parametr: Any?) {
        navigateModel = parametr as! WelcomNavigateModel
    }
    
    func loadNext() {
        GlobalVariable.isRegistration = true
        self.delegate?.loadStoryboard(storyboard: Storyboard.main)
    }
}
