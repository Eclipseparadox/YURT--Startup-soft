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
    var unitOfWork: StorageProviderType {
        return define(scope: .lazySingleton, init: RealmStorageProvider())
    }
    var notificationError: INotificationError {
        return define(scope: .lazySingleton, init: NotificationError())
    }
    var accountService: IAccountService {
        return define(scope: .lazySingleton, init: AccountService())
    }
    var documentService: DocumentServiceType {
        return define(scope: .lazySingleton, init: DocumentService())
    }
}
