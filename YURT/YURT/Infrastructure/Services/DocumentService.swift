//
//  DocumentService.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol DocumentServiceType {
    func uploadDocument(type: DocumentType, image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<(Bool, String?)>
    func getDocuments(delegate: DocumentContainerDelegate, publisher: PublishSubject<(Bool, DocumentType)>) -> Observable<(SttObservableCollection<(SttObservableCollection<DocumentEntityPresenter>, DocumentsEntityHeaderPresenter)>, Bool)>
    func deleteDocument(id: String) -> Observable<Bool>
    func sendDocument() -> Observable<Bool>
}

class DocumentService: DocumentServiceType {
    
    var _dataProvider: DataProviderType!
    var _notificatonError: NotificationErrorType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func uploadDocument(type: DocumentType, image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<(Bool, String?)> {
        let _type = type.isFinancies() ? DocumentTypeApiModel.financial : DocumentTypeApiModel.personal
        return _notificatonError.useError(observable: _dataProvider.uploadImage(image: image, progresHandler: progresHandler)
            .flatMap( { self._dataProvider.addDocument(model: AddDocumentApiModel(id: nil, type: _type, docType: type, image: $0)) } )
            .map({ (true, $0.id) }))
            .inBackground()
            .observeInUI()
    }
    
    func getDocuments(delegate: DocumentContainerDelegate, publisher: PublishSubject<(Bool, DocumentType)>) -> Observable<(SttObservableCollection<(SttObservableCollection<DocumentEntityPresenter>, DocumentsEntityHeaderPresenter)>, Bool)> {
        
        let personalDocuments = SttObservableCollection<DocumentEntityPresenter>()
        personalDocuments.append(contentsOf: [
                        DocumentEntityPresenter(type: .selfie, delegate: delegate, observer: publisher),
                        DocumentEntityPresenter(type: .signature, delegate: delegate, observer: publisher),
                        DocumentEntityPresenter(type: .dlicense, delegate: delegate, observer: publisher),
                        DocumentEntityPresenter(type: .passport, delegate: delegate, observer: publisher),
                        DocumentEntityPresenter(type: .SIN, delegate: delegate, observer: publisher)
        ])
        let financiedDocuments = SttObservableCollection<DocumentEntityPresenter>()
        financiedDocuments.append(contentsOf: [
                        DocumentEntityPresenter(type: .cheque, delegate: delegate, observer: publisher),
                        DocumentEntityPresenter(type: .tax, delegate: delegate, observer: publisher),
                        DocumentEntityPresenter(type: .CPS, delegate: delegate, observer: publisher),
                        DocumentEntityPresenter(type: .bank, delegate: delegate, observer: publisher)
                        //DocumentEntityPresenter(type: .uBill, delegate: self),
        ])
        
        let documents = SttObservableCollection<(SttObservableCollection<DocumentEntityPresenter>, DocumentsEntityHeaderPresenter)>()
        
        documents.append((personalDocuments,
                          DocumentsEntityHeaderPresenter(title: "Personal documents:",
                                                         total: personalDocuments.count,
                                                         observable: publisher.asObservable(),
                                                         isFinanices: false)))
        documents.append((financiedDocuments,
                          DocumentsEntityHeaderPresenter(title: "Financial documents:",
                                                         total: financiedDocuments.count,
                                                         observable: publisher.asObservable(),
                                                         isFinanices: true)))
        
        return self._notificatonError.useError(observable: Observable<(SttObservableCollection<(SttObservableCollection<DocumentEntityPresenter>, DocumentsEntityHeaderPresenter)>, Bool)>.create { (observer) -> Disposable in
            observer.onNext((documents, false))
            return self._dataProvider.getDocument()
                .subscribe(onNext: { (models) in
                    documents[0].1.uploadedsCount = 0
                    documents[1].1.uploadedsCount = 0

                    for item in models.documents {
                        var nIndex = 0
                        if item.name.isFinancies() {
                            nIndex = 1
                        }
                        if let index = documents[nIndex].0.index(where: { $0.documentType == item.name }) {
                            documents[nIndex].0[index].insertData(data: item)
                            if documents[nIndex].1.uploadedsCount < documents[nIndex].1.totalCountDocument {
                                documents[nIndex].1.uploadedsCount += 1
                            }
                        }
                        else {
                            fatalError("nani da fuck")
                        }
                    }
                    
                    observer.onNext((documents, models.isSentToReview))
                }, onError: observer.onError(_:), onCompleted: observer.onCompleted)
        })
    }
    
    func deleteDocument(id: String) -> Observable<Bool> {
        return _notificatonError.useError(observable: _dataProvider.deleteDocument(id: id))
            .inBackground()
            .observeInUI()
    }
    
    func sendDocument() -> Observable<Bool> {
        return _notificatonError.useError(observable: _dataProvider.sendDocuments())
            .inBackground()
            .observeInUI()
    }
}
