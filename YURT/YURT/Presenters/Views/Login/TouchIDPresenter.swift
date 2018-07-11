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
    
    override func prepare(parametr: Any?) {
        let param = parametr as! (String, String)
        
        email = param.0
        password = param.1
    }
    
    func clickYes() {
        KeychainSwift().set(email, forKey: Constants.idEmeail)
        KeychainSwift().set(password, forKey: Constants.idPassword)
        loadStoryboard()
    }
    
    func clickNo() {
        loadStoryboard()
    }
    
    private func loadStoryboard() {
        self.delegate?.loadStoryboard(storyboard: Storyboard.main)
    }
}
