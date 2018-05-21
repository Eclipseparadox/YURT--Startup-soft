//
//  ServiceAssembly.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import EasyDi

class ServiceAssembly: Assembly {
    var apiService: IApiService {
        return define(scope: .lazySingleton, init: ApiService())
    }
    var httpService: IHttpService {
        return define(scope: .lazySingleton, init: HttpService())
    }
    var unitOfWork: IUnitOfWork {
        return define(scope: .lazySingleton, init: UnitOfWork())
    }
    var notificationError: INotificationError {
        return define(scope: .lazySingleton, init: NotificationError())
    }
}
