//
//  BaseLendersPresenter.swift
//  YURT
//
//  Created by Standret on 14.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseLenderProtocol: SttViewContolable {
    func reloadLenders()
}

class BaseLendersPresenter<T>: SttPresenter<T>, OfferItemDelegate {
    
    var _offerInteractor: OfferInteractorType!
    private var viewDelegate: BaseLenderProtocol? { return delegate as? BaseLenderProtocol }
    private var busPublisher: PublishSubject<OfferStatus?>!
    var type: OfferStatus!
    
    var refresh: SttComand!
    var loadNext: SttComand!
    
    var lenders = SttObservableCollection<LenderPresenter>() {
        didSet {
            (delegate as! BaseLenderProtocol).reloadLenders()
        }
    }
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        refresh = SttComand(delegate: self, handler: { $0.updateOffers() })
        refresh.addHandler(start: nil, end: { [weak self] in self?.busPublisher.onNext(self!.type) })
        loadNext = SttComand(delegate: self, handler: { $0.updateOffers(skip: $0.lenders.count) })
        
        refresh.singleCallEndCallback = false
    }
    
    // mainContainer doing refresh data
    override func prepare(parametr: Any?) {
        busPublisher = parametr as! PublishSubject<OfferStatus?>
        _ = busPublisher.subscribe(onNext: { [weak self] stat in
            if stat == nil {
                self?.refresh.execute()
            }
        })
    }
    
    func refreshOffers() {
        busPublisher.onNext(nil)
        //refresh.execute()
    }
    
    // MARK: -- OfferItemDelegate
    
    func openOffers(data: OfferApiModel) {
        viewDelegate?.navigate(storyboard: Storyboard.offer, to: ViewOfferPresenter.self, typeNavigation: .push, withParametr: data, callback: { [weak self] res in
            self?.busPublisher.onNext(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                if (res as! Bool)  {
                    self?.viewDelegate?.sendMessage(title: "Offer has been approved", message: nil)
                }
                else {
                    self?.viewDelegate?.sendMessage(title: "Offer has been rejected", message: nil)
                }
            })
        })
    }
    
    private func updateOffers(skip: Int = 0) {
        _ = refresh.useWork(observable: _offerInteractor.getOffers(type: type, skip: 0))
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
