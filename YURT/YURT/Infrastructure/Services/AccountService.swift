//
//  AccountService.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol IAccountService: class {
    func existsEmail(email: String) -> Observable<Bool>
    func uploadUserAvatar(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel>
    func signUp(firstName: String, lastName: String, location: String?, phone: String?, email: String, password: String, image: ResultUploadImageApiModel?) -> Observable<Bool>
    func signIn(email: String, password: String) -> Observable<(Bool, String)>
}

class AccountService: IAccountService {
    
    var _apiService: IApiService!
    var _notificatonError: INotificationError!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func existsEmail(email: String) -> Observable<Bool> {
        return _notificatonError.useError(observable: _apiService.emailExists(email: email))
    }
    
    func uploadUserAvatar(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel> {
        return _notificatonError.useError(observable: _apiService.uploadImage(image: image, progresHandler: progresHandler))
    }
    
    func signUp(firstName: String, lastName: String, location: String?, phone: String?, email: String, password: String, image: ResultUploadImageApiModel?) -> Observable<Bool> {
        return _notificatonError.useError(observable: _apiService.signUp(model: BorrowerSignUp(firstName: firstName, lastName: lastName, email: email, password: password, phoneNumber: phone, location: location, image: image)))
    }
    func signIn(email: String, password: String)  -> Observable<(Bool, String)> {
        return Observable<(Bool, String)>.create({ (observer) -> Disposable in
            self._notificatonError.useError(observable: self._apiService.signIn(email: email, password: password), ignoreBadRequest: true)
                .subscribe(onNext: { (authModel) in
                    observer.onNext((true, ""))
                }, onError: { (error) in
                    observer.onNext((false, "Email or password is incorrect"))
                })
        })
    }
}
