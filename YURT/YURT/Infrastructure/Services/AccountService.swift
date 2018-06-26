//
//  AccountService.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift
import KeychainSwift

protocol IAccountService: class {
    func existsEmail(email: String) -> Observable<Bool>
    func uploadUserAvatar(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel>
    func signUp(firstName: String, lastName: String, location: String?, phone: String?, email: String, password: String, image: ResultUploadImageApiModel?) -> Observable<Bool>
    func signIn(email: String, password: String) -> Observable<(Bool, String)>
    
    var sesionIsExpired: Observable<Bool> { get }
}

class AccountService: IAccountService {
    
    var _dataProvider: DataProviderType!
    var _notificatonError: NotificationErrorType!
    var _unitOfWork: StorageProviderType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    var sesionIsExpired: Observable<Bool> { return _unitOfWork.auth.exists(filter: nil)
        .flatMap({ (res) -> Observable<Bool> in
            if res {
                return self._unitOfWork.auth.getOne(filter: nil).map({ $0.dateCreated.differenceInMinutes() > 60 ? false : true })
            }
            else {
                return Observable.from([false])
            }
        })
    }
    
    func existsEmail(email: String) -> Observable<Bool> {
        return _notificatonError.useError(observable: _dataProvider.emailExists(email: email))
            .inBackground()
            .observeInUI()
    }
    
    func uploadUserAvatar(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel> {
        return _notificatonError.useError(observable: _dataProvider.uploadImage(image: image, progresHandler: progresHandler))
            .inBackground()
            .observeInUI()
    }
    
    func signUp(firstName: String, lastName: String, location: String?, phone: String?, email: String, password: String, image: ResultUploadImageApiModel?) -> Observable<Bool> {
        let signUpObservable = _dataProvider.signUp(model: BorrowerSignUp(firstName: firstName, lastName: lastName, email: email, password: password, phoneNumber: phone, location: location, image: image))
        let signInObservable = signIn(email: email, password: password)
        return _notificatonError.useError(observable: signUpObservable
            .flatMap({ _ in signInObservable }))
            .map( { $0.0 } )
            .inBackground()
            .observeInUI()
    }
    func signIn(email: String, password: String)  -> Observable<(Bool, String)> {
        return self._notificatonError.useError(observable:
                self._dataProvider.signIn(email: email, password: password)
                    .map({ _ in (true, "") })
                    .inBackground()
                    .observeInUI(), ignoreBadRequest: true)
            .catchError({ _ in Observable.from([(false, "Email or password is incorrect")])})
    }
}
