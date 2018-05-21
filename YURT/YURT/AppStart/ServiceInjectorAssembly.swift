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
    
    // Inject service into presenter
    
    //  Inject Service into service
    
    func inject(into service: ApiService) {
        let _:ApiService = define(init: service) {
            $0._httpService = self.serviceAssembly.httpService
            $0._unitOfWork = self.serviceAssembly.unitOfWork
            return $0
        }
    }
    
    func inject<T>(into service: SttPresenter<T>) {
        let _:SttPresenter<T> = define(init: service) {
            $0._notificationError = self.serviceAssembly.notificationError
            return $0
        }
    }
}
