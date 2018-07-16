//
//  ForgotPasswordPresenter.swift
//  YURT
//
//  Created by Standret on 11.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol ForgotPasswordDelegate: SttViewContolable {
    func reloadError()
}

class ForgotPasswordPresenter: SttPresenter<ForgotPasswordDelegate> {
    
    var _accountService: AccountServiceType!
    
    var reset: SttComand!
    
    var email: String = "" {
        didSet {
            emailError = ValidateField.email.validate(rawObject: email)
            delegate?.reloadError()
        }
    }
    var emailError = (ValidationResult.ok, "")

    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        reset = SttComand(delegate: self, handler: { $0.onReset() }, handlerCanExecute: { !SttString.isWhiteSpace(string: $0.email) && $0.emailError.0 == .ok })
    }
    
    private func onReset() {
        _ = reset.useWork(observable: _accountService.forgotPassword(email: email))
            .subscribe(onNext: {
                if $0 {
                    self.delegate?.navigate(to: "forpasss2", withParametr: nil, callback: { _ in self.delegate?.close(animated: true) } )
                }
            })
    }
}
