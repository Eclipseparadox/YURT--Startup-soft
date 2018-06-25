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

enum DocumentType: String, Codable {
    case selfie = "Your Selfie"
    case signature = "Your Signature"
    case dlicense = "Driver's License"
    case passport = "Passport"
    case SIN = "Social Insurance Number (SIN)"
    case cheque = "Void Cheque"
    case tax = "Tax Assessments (2 years)"
    case CPS = "Current Pay Stub"
    case bank = "Bank Statements"
    case uBill = "Utility Bill"
    case none = ""
    
    func isFinancies() -> Bool {
        return self == .cheque || self == .tax || self == .CPS || self == .bank || self == .uBill
    }
    func needUseFrontCamera() -> Bool {
        return self == .selfie
    }
}

enum DocumentItemType {
    case noDocument, document
}

protocol DocumentEntityDelegate: SttViewable {
    func donwloadImageComplete(isSuccess: Bool)
    func changeProgress(label: String)
}

protocol DocumentContainerDelegate: class {
    func takePhoto(type: DocumentType, callback: @escaping (UIImage) -> Void)
    func showPhoto(type: (DocumentType, Image, String), callback: @escaping (Bool) -> Void)
    func reloadItem(type: DocumentType)
}

class DocumentEntityPresenter: SttPresenter<DocumentEntityDelegate> {
    
    var id: String?
    var documentType: DocumentType!
    var documentsName: String!
    var takesDate: Date?
    var isLoaded: Bool!
    var type: DocumentItemType!
    var image: Image?
    var observer: PublishSubject<(Bool, DocumentType)>!
    weak var itemDelegate: DocumentContainerDelegate!
    var donwloadInProgress = false
    
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
        self.takesDate = data.lastUpdate
       // observer.onNext((true, documentType))
    }
    
    var disposeable: Disposable?
    func clickOnItem () {
        if !donwloadInProgress {
            if type == DocumentItemType.noDocument {
                disposeable?.dispose()
                itemDelegate.takePhoto(type: documentType) { [weak self] (image) in
                    self?.type = .document
                    self?.image = Image(image: image)
                    self?.takesDate = Date()
                    
                    self?.donwloadInProgress = true
                    self?.delegate?.changeProgress(label: PercentConverter().convert(value: 0.0))
                    self?.disposeable = self?._documentService.uploadDocument(type: self!.documentType!, image: (self!.image?.image!)!, progresHandler: { val in
                        self?.delegate?.changeProgress(label: PercentConverter().convert(value: val))
                        self?.donwloadInProgress = true
                    }).subscribe(onNext:{
                        self?.id = $0.1
                        self?.delegate?.donwloadImageComplete(isSuccess: $0.0)
                        self?.donwloadInProgress = false
                        self?.observer.onNext((true, self!.documentType))
                    }, onError: { error in
                        self?.donwloadInProgress = false
                        self?.type = .noDocument
                        self?.itemDelegate.reloadItem(type: self!.documentType)
                    })
                }
            }
            else {
                if let _id = id {
                    itemDelegate.showPhoto(type: (documentType, image!, _id)) { [weak self] (status) in
                        if (status) {
                            self?.type = .noDocument
                            self?.observer.onNext((false, self!.documentType))
                        }
                    }
                }
            }
        }
    }
}
