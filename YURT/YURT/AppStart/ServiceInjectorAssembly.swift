//
//  ServiceInjectorAssembly.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import EasyDi

class ServiceInjectorAssembly: Assembly {
    
    lazy var serviceAssembly: ServiceAssembly = self.context.assembly()
    
    func inject(into service: AppDelegate) {
        let _:AppDelegate = define(init: service) {
            $0._accountService = self.serviceAssembly.accountService
            return $0
        }
    }
    
    // Inject service into presenter
    
    func inject<T>(into service: SttPresenter<T>) {
        let _:SttPresenter<T> = define(init: service) {
            $0._notificationError = self.serviceAssembly.notificationError
            return $0
        }
    }
    
    func inject<T>(into service: BaseLendersPresenter<T>) {
        let _:BaseLendersPresenter<T> = define(init: service) {
            $0._offerInteractor = self.serviceAssembly.offerInteractor
            return $0
        }
    }
    
    func inject(into service: SignUpPresenter) {
        let _:SignUpPresenter = define(init: service) {
            $0._accountService = self.serviceAssembly.accountService
            return $0
        }
    }
    
    func inject(into service: DocumentEntityPresenter) {
        let _:DocumentEntityPresenter = define(init: service) {
            $0._documentService = self.serviceAssembly.documentService
            return $0
        }
    }
    
    func inject(into service: DocumentsPresenter) {
        let _:DocumentsPresenter = define(init: service) {
            $0._documentService = self.serviceAssembly.documentService
            return $0
        }
    }
    
    func inject(into service: StartPagePresenter) {
        let _:StartPagePresenter = define(init: service) {
            $0._accountService = self.serviceAssembly.accountService
            return $0
        }
    }
    
    func inject(into service: ShowPhotoPresenter) {
        let _:ShowPhotoPresenter = define(init: service) {
            $0._documentService = self.serviceAssembly.documentService
            return $0
        }
    }
    
    func inject(into service: ViewOfferPresenter) {
        let _:ViewOfferPresenter = define(init: service) {
            $0._offerInteractor = self.serviceAssembly.offerInteractor
            return $0
        }
    }
    
    func inject(into service: RejectOfferPresenter) {
        let _:RejectOfferPresenter = define(init: service) {
            $0._offerInteractor = self.serviceAssembly.offerInteractor
            return $0
        }
    }
    
    func inject(into service: ProfilePresenter) {
        let _:ProfilePresenter = define(init: service) {
            $0._profileInteractor = self.serviceAssembly.profileInteractor
            return $0
        }
    }
    
    //  Inject Service into service
    
    // Inject into DataProviders
    
    func inject(into service: ApiDataProvider) {
        let _:ApiDataProvider = define(init: service) {
            $0._httpService = self.serviceAssembly.httpService
            $0._unitOfWork = self.serviceAssembly.storageProvider
            return $0
        }
    }
    func inject(into service: DataProvider) {
        let _:DataProvider = define(init: service) {
            $0._apiDataProvider = self.serviceAssembly.apiDataProvider
            $0._storageProvider = self.serviceAssembly.storageProvider
            return $0
        }
    }
    
    
    func inject(into service: AccountService) {
        let _:AccountService = define(init: service) {
            $0._dataProvider = self.serviceAssembly.dataProvider
            $0._notificatonError = self.serviceAssembly.notificationError
            return $0
        }
    }
    
    func inject(into service: DocumentService) {
        let _:DocumentService = define(init: service) {
            $0._dataProvider = self.serviceAssembly.dataProvider
            $0._notificatonError = self.serviceAssembly.notificationError
            return $0
        }
    }
    
    func inject(into service: OfferInteractor) {
        let _:OfferInteractor = define(init: service) {
            $0._dataProvider = self.serviceAssembly.dataProvider
            $0._notificatonError = self.serviceAssembly.notificationError
            return $0
        }
    }
    
    func inject(into service: ProfileInteractor) {
        let _:ProfileInteractor = define(init: service) {
            $0._dataProvider = self.serviceAssembly.dataProvider
            $0._notificatonError = self.serviceAssembly.notificationError
            return $0
        }
    }
}
