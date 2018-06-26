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
    
    var httpService: SttHttpServiceType {
        return define(scope: .lazySingleton, init: SttHttpService())
    }
    
    // data providers
    var apiDataProvider: ApiDataProviderType {
        return define(scope: .lazySingleton, init: ApiDataProvider())
    }
    var storageProvider: StorageProviderType {
        return define(scope: .lazySingleton, init: RealmStorageProvider())
    }
    var dataProvider: DataProviderType {
        return define(scope: .lazySingleton, init: DataProvider())
    }
    
    // services, interactors
    var notificationError: NotificationErrorType {
        return define(scope: .lazySingleton, init: NotificationError())
    }
    var accountService: IAccountService {
        return define(scope: .lazySingleton, init: AccountService())
    }
    var documentService: DocumentServiceType {
        return define(scope: .lazySingleton, init: DocumentService())
    }
    var offerInteractor: OfferInteractorType {
        return define(scope: .lazySingleton, init: OfferInteractor())
    }
}
