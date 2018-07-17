//
//  ProfileInteractor.swift
//  YURT
//
//  Created by Standret on 06.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileInteractorType {
    func getProfile() -> Observable<ProfileViewModel>
    func updateProfile(firstName: String, lastName: String, location: String, phone: String, skype: String?, role: String?,
                       linkedin: String?, email: String, education: String?, image: ResultUploadImageApiModel?) -> Observable<Bool>
}

class ProfileInteractor: ProfileInteractorType {
    
    var _dataProvider: DataProviderType!
    var _notificatonError: NotificationErrorType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getProfile() -> Observable<ProfileViewModel> {
        return _notificatonError.useError(observable: _dataProvider.getProfile()
            .map({ ProfileViewModel(raw: $0) }))
            .inBackground()
            .observeInUI()
    }
    
    func updateProfile(firstName: String, lastName: String, location: String, phone: String,
                       skype: String?, role: String?, linkedin: String?, email: String, education: String?, image: ResultUploadImageApiModel?) -> Observable<Bool> {
        
        return _notificatonError.useError(observable:
            _dataProvider.updateProfile(data: UpdateProfileApiModel(image: image,
                                     firstName: firstName,
                                     lastName: lastName,
                                     linkedInUrl: linkedin,
                                     phoneNumber: phone,
                                     email: email,
                                     skype: skype,
                                     location: location,
                                     education: education,
                                     work: role)))
            .inBackground()
            .observeInUI()
        
    }
}
