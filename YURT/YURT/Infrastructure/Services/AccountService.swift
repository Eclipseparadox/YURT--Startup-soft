//
//  AccountService.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol IAccountService {
    func existsEmail(email: String) -> Observable<Bool>
    func uploadUserAvatar(image: UIImage) -> Observable<ResultUploadImageApiModel>
    func signUp(firstName: String, lastName: String, location: String?, phone: String?, email: String, password: String, image: ResultUploadImageApiModel?) -> Observable<Bool>
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
    
    func uploadUserAvatar(image: UIImage) -> Observable<ResultUploadImageApiModel> {
        return _notificatonError.useError(observable: _apiService.uploadImage(image: image))
    }
    
    func signUp(firstName: String, lastName: String, location: String?, phone: String?, email: String, password: String, image: ResultUploadImageApiModel?) -> Observable<Bool> {
        return _notificatonError.useError(observable: _apiService.signUp(model: BorrowerSignUp(firstName: firstName, lastName: lastName, email: email, password: password, phoneNumber: phone, location: location, image: image)))
    }
}
