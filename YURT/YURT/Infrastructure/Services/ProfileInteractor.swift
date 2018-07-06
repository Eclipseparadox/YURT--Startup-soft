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
    }
}
