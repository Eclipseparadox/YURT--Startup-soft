//
//  DocumentEntityPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

enum DocumentType {
    case selfie, signature, dlicense, passport, SIN
    case cheque, tax, CPS, bank, uBill
    
    func isFinancies() -> Bool {
        return self == .cheque || self == .tax || self == .CPS || self == .bank || self == .uBill
    }
}

enum DocumentItemType {
    case noDocument, document
}

protocol DocumentEntityDelegate: Viewable {
    
}

protocol DocumentContainerDelegate: class {
    func takePhoto(type: DocumentType, callback: @escaping (Data) -> Void)
}

class DocumentEntityPresenter: SttPresenter<DocumentEntityDelegate> {
    
    var documentType: DocumentType!
    var documentsName: String!
    var takesDate: Date!
    var isLoaded: Bool!
    var type: DocumentItemType!
    var image: Image?
    var observer: PublishSubject<(Bool, DocumentType)>!
    weak var itemDelegate: DocumentContainerDelegate!
    
    
    convenience init(type: DocumentType, delegate: DocumentContainerDelegate, observer: PublishSubject<(Bool, DocumentType)>) {
        self.init()
        self.documentsName = DocumentFactories.getTitle(type: type)
        self.type = .noDocument
        self.itemDelegate = delegate
        self.documentType = type
        self.observer = observer
    }
    
    func clickOnItem () {
        if type == DocumentItemType.noDocument {
            itemDelegate.takePhoto(type: documentType) { [weak self] (data) in
                self?.type = .document
                self?.image = Image(data: data)
                self?.takesDate = Date()
            }
        }
    }
}
