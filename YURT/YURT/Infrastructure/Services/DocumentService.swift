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
    func getDocuments(delegate: DocumentContainerDelegate, publisher: PublishSubject<(Bool, DocumentType)>) -> Observable<(([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter]), Bool)>
    func deleteDocument(id: String) -> Observable<Bool>
    func sendDocument() -> Observable<Bool>
}

class DocumentService: DocumentServiceType {
    
    var _apiService: IApiService!
    var _notificatonError: INotificationError!
    var _unitOfWork: StorageProviderType!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func uploadDocument(type: DocumentType, image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<(Bool, String?)> {
        let _type = type.isFinancies() ? DocumentTypeApiModel.financial : DocumentTypeApiModel.personal
        var id: String?
        return _notificatonError.useError(observable: _apiService.uploadImage(image: image, progresHandler: progresHandler)
            .flatMap( { self._apiService.addDocument(model: AddDocumentApiModel(id: nil, type: _type, docType: type, image: $0)) } ))
            .flatMap({ model -> Observable<Bool> in
                id = model.id
                return self._unitOfWork.borrowerDocument.update(update: { (models) in
                    models.documents.append(model.serialize())
                    models.isSentToReview = false
                }, filter: nil).toObservable()
            }).map({ ($0, id) })
    }
    
    func getDocuments(delegate: DocumentContainerDelegate, publisher: PublishSubject<(Bool, DocumentType)>) -> Observable<(([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter]), Bool)> {
        
        var documents = ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])([], [])

        documents.0.append([
            DocumentEntityPresenter(type: .selfie, delegate: delegate, observer: publisher),
            DocumentEntityPresenter(type: .signature, delegate: delegate, observer: publisher),
            DocumentEntityPresenter(type: .dlicense, delegate: delegate, observer: publisher),
            DocumentEntityPresenter(type: .passport, delegate: delegate, observer: publisher),
            DocumentEntityPresenter(type: .SIN, delegate: delegate, observer: publisher)
            ])
        documents.0.append([
            DocumentEntityPresenter(type: .cheque, delegate: delegate, observer: publisher),
            DocumentEntityPresenter(type: .tax, delegate: delegate, observer: publisher),
            DocumentEntityPresenter(type: .CPS, delegate: delegate, observer: publisher),
            DocumentEntityPresenter(type: .bank, delegate: delegate, observer: publisher)
            //DocumentEntityPresenter(type: .uBill, delegate: self),
            ])
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Personal documents:", total: documents.0[0].count, observable: publisher.asObservable(), isFinanices: false))
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Financial documents:", total: documents.0[1].count, observable: publisher.asObservable(), isFinanices: true))
        
        return self._notificatonError.useError(observable: Observable<(([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter]), Bool)>.create { (observer) -> Disposable in
            observer.onNext((documents, false))
            return self._apiService.getDocument()
                .subscribe(onNext: { (models) in
                    documents.1[0].uploadedsCount = 0
                    documents.1[1].uploadedsCount = 0

                    for item in models.documents {
                        var nIndex = 0
                        if item.name.isFinancies() {
                            nIndex = 1
                        }
                        if let index = documents.0[nIndex].index(where: { $0.documentType == item.name }) {
                            documents.0[nIndex][index].insertData(data: item)
                            if documents.1[nIndex].uploadedsCount < documents.1[nIndex].totalCountDocument {
                                documents.1[nIndex].uploadedsCount += 1
                            }
                        }
                        else {
                            fatalError("da fuck")
                        }
                    }
                    
                    observer.onNext((documents, models.isSentToReview))
                }, onError: observer.onError(_:), onCompleted: observer.onCompleted)
        })
    }
    
    func deleteDocument(id: String) -> Observable<Bool> {
        return _notificatonError.useError(observable:
            _unitOfWork.borrowerDocument.getOne(filter: nil)
                .flatMap({ self._apiService.deleteDocument(model: DeleteDocumentApiModel(documentId: id, image: $0.documents[$0.documents.index(where: { $0.id == id })!].image!.deserialize())) })
                .flatMap({ _ in self._unitOfWork.borrowerDocument.update(update: {
                    $0.documents.remove(at: $0.documents.index(where: { $0.id == id })!)
                    $0.isSentToReview = false
                }, filter: nil).toObservable() })
        )
    }
    
    func sendDocument() -> Observable<Bool> {
        return _notificatonError.useError(observable: _apiService.sendDocuments()
            .flatMap({ _ in self._unitOfWork.borrowerDocument.update(update: { $0.isSentToReview = true }, filter: nil).toObservable() }))
    }
}
