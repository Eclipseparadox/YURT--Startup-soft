//
//  ViewOfferPresenter.swift
//  YURT
//
//  Created by Standret on 15.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

protocol ViewOfferDelegate: SttViewContolable {
    func deleteButtons(status: Bool)
}

class ViewOfferPresenter: SttPresenter<ViewOfferDelegate>, DocumentLenderItemDelegate {
    
    var _offerInteractor: OfferInteractorType!
    
    var data: OfferApiModel!
    var collection = SttObservableCollection<OfferDetailPresenter>()
    var documentCollection = SttObservableCollection<DocumentLenderCellPresenter>()
    var aprove: SttComand!
    
    var showButtons: Bool { return data.status == .pending }
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)

        aprove = SttComand(delegate: self, handler: { $0.onAprove() })
    }
    
    override func prepare(parametr: Any?) {
        data = parametr as! OfferApiModel
        
        collection.append(OfferDetailPresenter(name: "Required down payment:", value: Double(data.downPayment), type: .currency))
        collection.append(OfferDetailPresenter(name: "Loan Amount:", value: Double(data.loan), type: .currency))
        collection.append(OfferDetailPresenter(name: "Rate:", value: Double(data.rate), type: .percent))
        collection.append(OfferDetailPresenter(name: "Term:", value: Double(data.term), type: .months))
        collection.append(OfferDetailPresenter(name: "Amorthization:", value: Double(data.amortization), type: .months))
        collection.append(OfferDetailPresenter(name: "PMI:", value: Double(data.pmi), type: .currency))
        collection.append(OfferDetailPresenter(name: "Lender Fees:", value: Double(data.lenderFees), type: .currency))
        collection.append(OfferDetailPresenter(name: "Monthly Payment:", value: Double(data.monthlyPayment), type: .currency))
        collection.append(OfferDetailPresenter(name: "Offer Hold:", value: Double(data.hold), type: .days))
        
        for item in data.files {
            documentCollection.append(DocumentLenderCellPresenter(url: item, delegate: self))
        }
    }
    
    func onAprove() {
        _ = aprove.useWork(observable: _offerInteractor.aproveOffer(id: data.id))
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.deleteButtons(status: true)
            })
    }
    
    func onClick(url: String, fileName: String) {
        delegate?.navigate(storyboard: Storyboard.offer, to: DocumentPreviewPresenter.self, typeNavigation: .modality, withParametr: (url, fileName))
    }
    
    func rejectClick() {
        delegate?.navigate(storyboard: Storyboard.offer, to: RejectOfferPresenter.self, typeNavigation: .push, withParametr: data, callback: { [weak self] (result) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.delegate?.deleteButtons(status: false)
            }
        })
    }
    
    func onError(error: SttBaseErrorType) {
        self.delegate?.sendError(error: error)
    }
}
