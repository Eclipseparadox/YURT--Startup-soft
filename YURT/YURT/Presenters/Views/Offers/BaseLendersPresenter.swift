//
//  BaseLendersPresenter.swift
//  YURT
//
//  Created by Standret on 14.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol BaseLenderProtocol: SttViewContolable {
    func reloadLenders()
}

class BaseLendersPresenter<T>: SttPresenter<T>, OfferItemDelegate {
    
    var _offerInteractor: OfferInteractorType!
    var viewDelegate: BaseLenderProtocol? { return delegate as? BaseLenderProtocol }
    var type: OfferStatus!
    
    var lenders = SttObservableCollection<LenderPresenter>() {
        didSet {
            (delegate as! BaseLenderProtocol).reloadLenders()
        }
    }
    
    func openOffers(data: OfferApiModel) {
        viewDelegate?.navigate(storyboard: .offer, to: ViewOfferPresenter.self, withParametr: data)
    }
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        super.presenterCreating()
        
        _ = _offerInteractor.getOffers(type: type, skip: 0)
            .subscribe(onNext: { [weak self] (lendersOffers) in
                print (lendersOffers.count)
                for item in lendersOffers {
                    item.itemDelegate = self
                }
                self?.lenders.removeAll()
                self?.lenders.append(contentsOf: lendersOffers)
            })
    }
}
