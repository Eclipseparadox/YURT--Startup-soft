//
//  DocumentsPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SINQ

protocol DocumentsDelegate: Viewable {
    func reloadItem(section: Int, row: Int)
    func progressCahnged()
    func reloadData()
}

class DocumentsPresenter: SttPresenter<DocumentsDelegate>, DocumentContainerDelegate {
    
    var documents: ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])!
    var totalDocument = 9
    var currentUploaded = 0 {
        didSet {
            self.delegate!.progressCahnged()
        }
    }
    
    var isSendToReview: Bool = false
    var _documentService: DocumentServiceType!
    var send: SttComand!
    var canSend: Bool { return currentUploaded == totalDocument && !isSendToReview }

    override func presenterCreating() {
        ServiceInjectorAssembly.instance().inject(into: self)
        send = SttComand(delegate: self, handler: { $0.onSend() }, handlerCanExecute: { $0.currentUploaded == $0.totalDocument })

        let publisher = PublishSubject<(Bool, DocumentType)>()
        
        _ = _documentService.getDocuments(delegate: self, publisher: publisher)
            .subscribe(onNext: { [weak self] (documents) in
                self?.documents = documents.0
                self?.isSendToReview = documents.1
                self?.currentUploaded = documents.0.1[0].uploadedsCount + documents.0.1[1].uploadedsCount
                self?.delegate!.reloadData()
                self?.delegate?.progressCahnged()
            })
        
        _ = publisher
            .subscribe(onNext: { [weak self] (arg) in
            if let _self = self {
                if arg.0 && _self.currentUploaded < _self.totalDocument {
                    if _self.currentUploaded == _self.totalDocument {
                    }
                    _self.currentUploaded += 1
                }
                else if _self.currentUploaded > 0 {
                    _self.isSendToReview = false
                    _self.currentUploaded -= 1
                }
            }
        })
    }
    
    func takePhoto(type: DocumentType, callback: @escaping (UIImage) -> Void) {
        delegate!.navigate(to: "takePhoto", withParametr: type) { [weak self] (data) in
            callback(data as! UIImage)
            if let _self = self {
                let section = _self.documents.0.index(where: { $0.contains(where: { $0.documentType == type })})
                let row = _self.documents.0[section!].index(where: { $0.documentType == type })
                _self.delegate!.reloadItem(section: section!, row: row!)
            }
        }
    }
    
    func showPhoto(type: (DocumentType, Image, String), callback: @escaping (Bool) -> Void) {
        delegate!.navigate(to: "showPhoto", withParametr: type) { (result) in
            callback(result as! Bool)
            if result as! Bool {
                let section = self.documents.0.index(where: { $0.contains(where: { $0.documentType == type.0 })})
                let row = self.documents.0[section!].index(where: { $0.documentType == type.0 })
                self.delegate!.reloadItem(section: section!, row: row!)
            }
        }
    }
    
    func onSend() {
        _ = send.useWork(observable: _documentService.sendDocument())
            .subscribe(onNext: { [weak self] (res) in
                if res {
                    self?.isSendToReview = true
                    self?.delegate?.progressCahnged()
                    self?.delegate?.sendMessage(title: "Success", message: "Your documents have been sent successfully")
                }
            })
    }
    
    func reloadItem(type: DocumentType) {
        let section = self.documents.0.index(where: { $0.contains(where: { $0.documentType == type })})
        let row = self.documents.0[section!].index(where: { $0.documentType == type })
        self.delegate!.reloadItem(section: section!, row: row!)
    }
}
