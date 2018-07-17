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
    func aproveOffer(id: String) -> Observable<Bool>
    func rejectOffer(id: String, message: String) -> Observable<Bool>
}

class OfferInteractor: OfferInteractorType {
    
    var _dataProvider: DataProviderType!
    var _notificatonError: NotificationErrorType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func getOffers(type: OfferStatus, skip: Int) -> Observable<[LenderPresenter]> {
        return _notificatonError.useError(observable: _dataProvider.getOffer(status: type, skip: skip)
            .map({ $0.map({ LenderPresenter(data: $0 ) }) }))
            .inBackground()
            .observeInUI()
    }
    func aproveOffer(id: String) -> Observable<Bool> {
        return _notificatonError.useError(observable: _dataProvider.aproveOffer(id: id))
            .inBackground()
            .observeInUI()
    }
    func rejectOffer(id: String, message: String) -> Observable<Bool> {
        return _notificatonError.useError(observable: _dataProvider.rejectOffer(id: id, message: message))
            .inBackground()
            .observeInUI()
    }
}
