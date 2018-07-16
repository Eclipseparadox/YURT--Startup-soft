//
//  ForgotPasswordStepThreePresenter.swift
//  YURT
//
//  Created by Standret on 16.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol ResetDelegate: SttViewContolable {
    func reloadError()
}

class ResetPresenter: SttPresenter<ResetDelegate> {
    
    var _accountService: AccountServiceType!
    
    var save: SttComand!
    
    private var code: String!
    private var email: String!
    
    var password: String = "" {
        didSet {
            passwordError = ValidateField.password.validate(rawObject: password)
            delegate?.reloadError()
        }
    }
    var passwordConfirm: String = "" {
        didSet {
            confirmPassworError = ValidateField.password.validate(rawObject: passwordConfirm)
            if confirmPassworError.0 == .ok {
                if password != passwordConfirm {
                    confirmPassworError = (ValidationResult.isNotMatch, "The paswords do not match")
                }
            }
            delegate?.reloadError()
        }
    }
    
    
    var passwordError = (ValidationResult.ok, "")
    var confirmPassworError = (ValidationResult.ok, "")
    
    override func prepare(parametr: Any?) {
        let param = parametr as! [String:String]
        code = param["code"]
        email = param["email"]
    }
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        save = SttComand(delegate: self, handler: { $0.onSave() }, handlerCanExecute: {
            !SttString.isWhiteSpace(string: $0.password) && !SttString.isWhiteSpace(string: $0.passwordConfirm)
            && $0.passwordError.0 == .ok && $0.confirmPassworError.0 == .ok })
    }
    
    private func onSave() {
        _ = save.useWork(observable: _accountService.resetPassword(code: code,
                                                                   email: email,
                                                                   password: password,
                                                                   confirmPassword: passwordConfirm))
            .subscribe(onNext: { _ in
                self.delegate?.navigate(to: "confirmReset", withParametr: nil, callback: nil)
            })
    }
}
