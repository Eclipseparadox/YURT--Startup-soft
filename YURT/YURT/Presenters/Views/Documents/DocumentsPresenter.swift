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

protocol DocumentsDelegate: Viewable {
    func reloadItem(section: Int, row: Int)
    func progressCahnged()
}

class DocumentsPresenter: SttPresenter<DocumentsDelegate>, DocumentContainerDelegate {
    
    var documents: ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])!
    var totalDocument = 9
    var currentUploaded = 0
    
    override func presenterCreating() {
        
        let publisher = PublishSubject<(Bool, DocumentType)>()
        
        documents =  ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])([], [])
        documents.0.append([
            DocumentEntityPresenter(type: .selfie, delegate: self, observer: publisher),
            DocumentEntityPresenter(type: .signature, delegate: self, observer: publisher),
            DocumentEntityPresenter(type: .dlicense, delegate: self, observer: publisher),
            DocumentEntityPresenter(type: .passport, delegate: self, observer: publisher),
            DocumentEntityPresenter(type: .SIN, delegate: self, observer: publisher)
            ])
        documents.0.append([
            DocumentEntityPresenter(type: .cheque, delegate: self, observer: publisher),
            DocumentEntityPresenter(type: .tax, delegate: self, observer: publisher),
            DocumentEntityPresenter(type: .CPS, delegate: self, observer: publisher),
            DocumentEntityPresenter(type: .bank, delegate: self, observer: publisher)
            //DocumentEntityPresenter(type: .uBill, delegate: self),
            ])
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Personal documents:", total: documents.0[0].count, observable: publisher.asObservable(), isFinanices: false))
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Financial documents:", total: documents.0[1].count, observable: publisher.asObservable(), isFinanices: true))
        
        delegate.progressCahnged()
        _ = publisher.subscribe(onNext: { [weak self] (arg) in
            if let _self = self {
                if arg.0 && _self.currentUploaded < _self.totalDocument {
                    _self.currentUploaded += 1
                }
                else if _self.currentUploaded > 0 {
                    _self.currentUploaded -= 1
                }
            }
        })
    }
    
    func takePhoto(type: DocumentType, callback: @escaping (UIImage) -> Void) {
        delegate.navigate(to: "takePhoto", withParametr: type) { [weak self] (data) in
            callback(data as! UIImage)
            if let _self = self {
                let section = _self.documents.0.index(where: { $0.contains(where: { $0.documentType == type })})
                let row = _self.documents.0[section!].index(where: { $0.documentType == type })
                _self.delegate.reloadItem(section: section!, row: row!)
            }
        }
        delegate.navigate(to: "takePhoto", withParametr: type, callback: { callback($0 as! UIImage) })
    }
}
