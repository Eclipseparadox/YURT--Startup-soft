//
//  StartPagePresenter.swift
//  YURT
//
//  Created by Standret on 17.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol StartPageDelegate: SttViewContolable {
    func addError()
}

class StartPagePresenter: SttPresenter<StartPageDelegate> {
    
    var signIn: SttComand!
    var linkedinAuth: SttComand!
    
    var _accountService: AccountServiceType!
    
    var email: String? = ""
    var password: String? = ""
    
    var linkedinAccesToken: String!
    
    var passwordError: String?
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        signIn = SttComand(delegate: self, handler: { $0.onSignIn() })
        linkedinAuth = SttComand(delegate: self, handler: { $0.onLinkedinAuth() },
                                       handlerCanExecute: { !SttString.isEmpty(string: $0.linkedinAccesToken) })
    }
    
    func onSignIn() {
        _ = signIn.useWork(observable: _accountService.signIn(email: email!, password: password!))
            .subscribe(onNext: { (res) in
                if res.0 {
                    self.delegate!.loadStoryboard(storyboard: Storyboard.main)
                }
                else {
                    self.passwordError = res.1
                    self.delegate!.addError()
                }
            })
    }
    
    func onLinkedinAuth() {
        _ = linkedinAuth.useWork(observable: _accountService.externalLogin(token: linkedinAccesToken))
            .subscribe(onNext: { _ in self.delegate!.loadStoryboard(storyboard: Storyboard.main) })
    }
}
