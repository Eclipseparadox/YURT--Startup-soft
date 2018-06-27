//
//  RejectOfferPresenter.swift
//  YURT
//
//  Created by Standret on 27.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol RejectOfferDelegate: SttViewContolable {
    func reloadSendState()
}

class RejectOfferPresenter: SttPresenter<RejectOfferDelegate> {
    
    var _offerInteractor: OfferInteractorType!
    
    var send: SttComand!
    
    var comment: String? {
        didSet {
            delegate?.reloadSendState()
        }
    }
    
    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        
        send = SttComand(delegate: self, handler: { $0.onSend() }, handlerCanExecute: { ($0.comment?.trimmingCharacters(in: .whitespaces).count ?? 0) > 0 })
    }
    
    var data: OfferApiModel!
    override func prepare(parametr: Any?) {
        data = parametr as! OfferApiModel
    }
    
    private func onSend() {
        delegate?.close(parametr: true)
    }
}
