//
//  OfferInteractor.swift
//  YURT
//
//  Created by Standret on 14.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol OfferInteractorType {
    func getOffers(type: OfferStatus, skip: Int) -> Observable<[LenderPresenter]>
}

class OfferInteractor: OfferInteractorType {
    
    var _apiService: IApiService!
    var _notificatonError: NotificationErrorType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getOffers(type: OfferStatus, skip: Int) -> Observable<[LenderPresenter]> {
        return _notificatonError.useError(observable: _apiService.getOffer(status: type, skip: skip)
            .map({ $0.map({ LenderPresenter(data: $0 ) }) }))
    }
}
