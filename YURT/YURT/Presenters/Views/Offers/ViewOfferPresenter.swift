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
    
}

class ViewOfferPresenter: SttPresenter<ViewOfferDelegate>, DocumentLenderItemDelegate {
    
    
    var data: OfferApiModel!
    var collection = SttObservableCollection<OfferDetailPresenter>()
    var documentCollection = SttObservableCollection<DocumentLenderCellPresenter>()
    
    override func prepare(parametr: Any?) {
        data = parametr as! OfferApiModel
        
        collection.append(OfferDetailPresenter(name: "Required down payment:", value: Double(data.downPayment), type: .currency))
        collection.append(OfferDetailPresenter(name: "Loan Amount:", value: Double(data.loan), type: .currency))
        collection.append(OfferDetailPresenter(name: "Rate:", value: Double(data.rate), type: .percent))
        collection.append(OfferDetailPresenter(name: "Term:", value: Double(data.term), type: .years))
        collection.append(OfferDetailPresenter(name: "Amorthization:", value: Double(data.amortization), type: .count))
        collection.append(OfferDetailPresenter(name: "PMI:", value: Double(data.pmi), type: .count))
        collection.append(OfferDetailPresenter(name: "Lender Fees:", value: Double(data.lenderFees), type: .count))
        collection.append(OfferDetailPresenter(name: "Monthly Payment:", value: Double(data.monthlyPayment), type: .currency))
        collection.append(OfferDetailPresenter(name: "Offer Hold:", value: Double(data.hold), type: .days))
        
        for item in data.files {
            documentCollection.append(DocumentLenderCellPresenter(url: item, delegate: self))
        }
    }
    
    func onClick(image: UIImage) {
        delegate?.navigate(storyboard: Storyboard.offer, to: DocumentPreviewPresenter.self, typeNavigation: .modality, withParametr: image, callback: nil)
    }
    func onError(error: SttBaseErrorType) {
        self.delegate?.sendError(error: error)
    }
}
