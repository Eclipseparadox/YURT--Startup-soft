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
    
    //  Inject Service into service
    
    func inject(into service: ApiService) {
        let _:ApiService = define(init: service) {
            $0._httpService = self.serviceAssembly.httpService
            $0._unitOfWork = self.serviceAssembly.unitOfWork
            return $0
        }
    }
    
    func inject(into service: AccountService) {
        let _:AccountService = define(init: service) {
            $0._apiService = self.serviceAssembly.apiService
            $0._notificatonError = self.serviceAssembly.notificationError
            $0._unitOfWork = self.serviceAssembly.unitOfWork
            return $0
        }
    }
    
    func inject(into service: DocumentService) {
        let _:DocumentService = define(init: service) {
            $0._apiService = self.serviceAssembly.apiService
            $0._notificatonError = self.serviceAssembly.notificationError
            $0._unitOfWork = self.serviceAssembly.unitOfWork
            return $0
        }
    }
}
