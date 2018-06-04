//
//  StartPagePresenter.swift
//  YURT
//
//  Created by Standret on 17.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol StartPageDelegate: Viewable {
    func addError()
}

class StartPagePresenter: SttPresenter<StartPageDelegate> {
    
    var signIn: SttComand!
    
    var _accountService: IAccountService!
    
    var email: String? = ""
    var password: String? = ""
    
    var passwordError: String?
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        signIn = SttComand(delegate: self, handler: { $0.onSignIn() })
    }
    
    func onSignIn() {
        _ = signIn.useWork(observable: _accountService.signIn(email: email!, password: password!))
            .subscribe(onNext: { (res) in
                if res.0 {
                    self.delegate.navigate(storyboardName: "Main", type: .modality, animated: true)
                }
                else {
                    self.passwordError = res.1
                    self.delegate.addError()
                }
            })
    }
}
