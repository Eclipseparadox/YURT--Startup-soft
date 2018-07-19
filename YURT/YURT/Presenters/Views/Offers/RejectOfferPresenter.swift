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
    func removePreviewVC()
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
        
        send = SttComand(delegate: self, handler: { $0.onSend() }, handlerCanExecute: {
            let count = ($0.comment?.trimmingCharacters(in: .whitespaces).count ?? 0)
            return count > 50 && count < 200
        })
    }
    
    var data: OfferApiModel!
    override func prepare(parametr: Any?) {
        data = parametr as! OfferApiModel
    }
    
    private func onSend() {
        _ = send.useWork(observable: _offerInteractor.rejectOffer(id: data.id, message: comment!))
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.removePreviewVC()
                self?.delegate?.close(parametr: true, animated: true)
            })
    }
}
