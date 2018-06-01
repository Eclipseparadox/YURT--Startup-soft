//
//  DocumentsPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol DocumentsDelegate: Viewable {
    func reloadItem(section: Int, row: Int)
}

class DocumentsPresenter: SttPresenter<DocumentsDelegate>, DocumentContainerDelegate {
    
    var documents: ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])!
    
    override func presenterCreating() {
        
        let publisher = PublishSubject<(Bool, DocumentType)>()
        
        documents =  ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])([], [])
        documents.0.append([
            DocumentEntityPresenter(type: .selfie, delegate: self),
            DocumentEntityPresenter(type: .signature, delegate: self),
            DocumentEntityPresenter(type: .dlicense, delegate: self),
            DocumentEntityPresenter(type: .passport, delegate: self),
            DocumentEntityPresenter(type: .SIN, delegate: self)
            ])
        documents.0.append([
            DocumentEntityPresenter(type: .cheque, delegate: self),
            DocumentEntityPresenter(type: .tax, delegate: self),
            DocumentEntityPresenter(type: .CPS, delegate: self),
            DocumentEntityPresenter(type: .bank, delegate: self),
            //DocumentEntityPresenter(type: .uBill, delegate: self),
            ])
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Personal documents:", total: documents.0[0].count))
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Financial documents:", total: documents.0[1].count))
    }
    
    func takePhoto(type: DocumentType, callback: @escaping (Data) -> Void) {
        delegate.navigate(to: "takePhoto", withParametr: type) { [weak self] (data) in
            callback(data as! Data)
            if let _self = self {
                let section = _self.documents.0.index(where: { $0.contains(where: { $0.documentType == type })})
                let row = _self.documents.0[section!].index(where: { $0.documentType == type })
                _self.delegate.reloadItem(section: section!, row: row!)
            }
        }
        delegate.navigate(to: "takePhoto", withParametr: type, callback: { callback($0 as! Data) })
    }
}
