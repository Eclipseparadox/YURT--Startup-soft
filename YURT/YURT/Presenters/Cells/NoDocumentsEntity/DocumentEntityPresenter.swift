//
//  DocumentEntityPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum DocumentType: String, Decodable, DictionaryCodable {
    case selfie = "Selfie"
    case signature = "Your signature"
    case dlicense = "Driver's license"
    case passport = "Passport"
    case SIN = "Social Insurance Card (SIN)"
    case cheque = "Void cheque"
    case tax = "Tax assesments (2 years)"
    case CPS = "Current pay stub"
    case bank = "Bank assesments"
    case uBill = "Utility bill"
    case none = ""
    
    func isFinancies() -> Bool {
        return self == .cheque || self == .tax || self == .CPS || self == .bank || self == .uBill
    }
}

enum DocumentItemType {
    case noDocument, document
}

protocol DocumentEntityDelegate: Viewable {
    func donwloadImageComplete(isSuccess: Bool)
    func changeProgress(label: String)
}

protocol DocumentContainerDelegate: class {
    func takePhoto(type: DocumentType, callback: @escaping (UIImage) -> Void)
    func showPhoto(type: (DocumentType, Image), callback: @escaping (Bool) -> Void)
}

class DocumentEntityPresenter: SttPresenter<DocumentEntityDelegate> {
    
    var id: String!
    var documentType: DocumentType!
    var documentsName: String!
    var takesDate: Date?
    var isLoaded: Bool!
    var type: DocumentItemType!
    var image: Image?
    var observer: PublishSubject<(Bool, DocumentType)>!
    weak var itemDelegate: DocumentContainerDelegate!
    
    var _documentService: DocumentServiceType!
    
    convenience init(type: DocumentType, delegate: DocumentContainerDelegate, observer: PublishSubject<(Bool, DocumentType)>) {
        
        self.init()
        self.documentsName = type.rawValue
        self.type = .noDocument
        self.itemDelegate = delegate
        self.documentType = type
        self.observer = observer
        
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func insertData(data: BorrowerDocumentApiModel) {
        type = .document
        documentsName = data.name.rawValue
        documentType = data.name
        id = data.id
        self.image = Image(url: data.image.preview.path)

       // observer.onNext((true, documentType))
    }
    
    var disposeable: Disposable?
    func clickOnItem () {
        if type == DocumentItemType.noDocument {
            disposeable?.dispose()
            itemDelegate.takePhoto(type: documentType) { [weak self] (image) in
                self?.type = .document
                self?.image = Image(image: image)
                self?.takesDate = Date()
                self?.observer.onNext((true, self!.documentType))
                
                self?.delegate?.changeProgress(label: PercentConverter().convert(value: 0.0))
                self?.disposeable = self?._documentService.uploadDocument(type: self!.documentType!, image: (self!.image?.image!)!, progresHandler: { self?.delegate?.changeProgress(label: PercentConverter().convert(value: $0)) }).subscribe(onNext:{ self?.delegate?.donwloadImageComplete(isSuccess: $0) })
            }
        }
        else {
            itemDelegate.showPhoto(type: (documentType, image!)) { [weak self] (status) in
                if (status) {
                    self?.type = .noDocument
                    self?.observer.onNext((false, self!.documentType))
                }
            }
        }
    }
}
