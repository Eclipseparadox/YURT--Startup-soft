//
//  TouchIDPresenter.swift
//  YURT
//
//  Created by Standret on 10.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import KeychainSwift

class TouchIDPresenter: SttPresenter<SttViewContolable> {
    
    private var email: String!
    private var password: String!
    private var navModel: WelcomNavigateModel!
    
    override func prepare(parametr: Any?) {
        navModel = parametr as! WelcomNavigateModel
        
        email = navModel.email
        password = navModel.password
    }
    
    func clickYes() {
        KeychainSwift().set(email, forKey: Constants.idEmeail)
        KeychainSwift().set(password, forKey: Constants.idPassword)
        welcome()
    }
    
    func clickNo() {
        welcome()
    }
    
    private func welcome() {
        self.delegate?.navigate(to: "welcome", withParametr: navModel, callback: nil)
    }
}
