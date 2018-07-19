//
//  OfferPresenter.swift
//  YURT
//
//  Created by Standret on 28.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol OfferDelegate: SttViewContolable {
    func reloadCounter(data: OfferCountApiModel)
}

class OfferPresenter: SttPresenter<OfferDelegate> {
    var _offerInteractor: OfferInteractorType!
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
    }
    
    func reloadCount() {
        _ = _offerInteractor.getCount()
            .subscribe(onNext: { (count) in
                self.delegate?.reloadCounter(data: count)
            })
    }
}
