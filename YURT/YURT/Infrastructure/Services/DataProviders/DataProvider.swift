//
//  DataProvider.swift
//  YURT
//
//  Created by Standret on 26.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift
import KeychainSwift

protocol DataProviderType {
    
    // accountDataProvider
    func emailExists(email: String) -> Observable<Bool>
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel>
    func signUp(model: BorrowerSignUp) -> Observable<Bool>
    func signIn(email: String, password: String) -> Observable<AuthApiModel>
    func externalLogin(token: String) -> Observable<AuthApiModel>
    func forgotPassword(data: ForgotPasswordApiModel) -> Observable<Bool>
    func resetPassword(data: ResetPasswordApiModel) -> Observable<Bool>
    
    // documentsDataProvider
    func getDocument() -> Observable<BorrowerDocumentModelApiModel>
    func addDocument(model: AddDocumentApiModel) -> Observable<BorrowerDocumentApiModel>
    func sendDocuments() -> Observable<Bool>
    func deleteDocument(id: String) -> Observable<Bool>
    
    // offersDataProvider
    func getOffer(status: OfferStatus, skip: Int) -> Observable<[OfferApiModel]>
    func aproveOffer(id: String) -> Observable<Bool>
    func rejectOffer(id: String, message: String) -> Observable<Bool>
    func getCount() -> Observable<OfferCountApiModel>
    
    // profileDataProvider
    func getProfile() -> Observable<ProfileApiModel>
    func updateProfile(data: UpdateProfileApiModel) -> Observable<Bool>
}

class DataProvider: DataProviderType {
 
    var _apiDataProvider: ApiDataProviderType!
    var _storageProvider: StorageProviderType!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    // accountDataProvider

    func emailExists(email: String) -> Observable<Bool> {
        return _apiDataProvider.emailExists(email: email)
            .map({ $0.isExist })
    }
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel> {
        return _apiDataProvider.uploadImage(image: image, progresHandler: progresHandler)
    }
    func signUp(model: BorrowerSignUp) -> Observable<Bool> {
        return _apiDataProvider.signUp(model: model)
    }
    func signIn(email: String, password: String) -> Observable<AuthApiModel> {
        return saveToken(observable: _apiDataProvider.signIn(email: email, password: password))
    }
    func externalLogin(token: String) -> Observable<AuthApiModel> {
        return saveToken(observable: _apiDataProvider.externalLogin(token: token))
    }
    func forgotPassword(data: ForgotPasswordApiModel) -> Observable<Bool> {
        return _apiDataProvider.forgotPassword(data: data)
    }
    func resetPassword(data: ResetPasswordApiModel) -> Observable<Bool> {
        return _apiDataProvider.resetPassword(data: data)
    }
    
    private func saveToken(observable: Observable<AuthApiModel>) -> Observable<AuthApiModel> {
        return observable.flatMap({ model -> Observable<AuthApiModel> in
            KeychainSwift().set(model.access_token, forKey: Constants.tokenKey)
            self._apiDataProvider.inserToken(token: model.access_token)
            return self._storageProvider.auth.saveOne(model: model)
                .toObservable()
                .map({ _ in model })
        })
    }

    
    // documentsDataProvider

    func getDocument() -> Observable<BorrowerDocumentModelApiModel> {
        let localDoc = _storageProvider.borrowerDocument.getOne(filter: nil)
            .map({ rr -> BorrowerDocumentModelApiModel in
                print("deserialize \(Thread.current)")
                let r = rr.deserialize()
                print("end deserialize")
                return r
            })
        let apiData = _apiDataProvider.getDocument()
            .saveInDB(saveCallback: _storageProvider.borrowerDocument.saveOne(model:))
        
        return Observable.merge([localDoc, apiData])
    }
    func addDocument(model: AddDocumentApiModel) -> Observable<BorrowerDocumentApiModel> {
        return _apiDataProvider.addDocument(model: model)
            .flatMap({ model -> Observable<BorrowerDocumentApiModel> in
                return self._storageProvider.borrowerDocument.update(update: { (models) in
                    models.documents.append(model.serialize())
                    models.isSentToReview = false
                }, filter: nil)
                    .toObservable()
                    .map({ _ in model})
            })
    }
    func sendDocuments() -> Observable<Bool> {
        return Observable.concat([_apiDataProvider.sendDocuments(),
                                  _storageProvider.borrowerDocument.update(update: { $0.isSentToReview = true }, filter: nil).toObservable()])

    }
    func deleteDocument(id: String) -> Observable<Bool> {
            return _storageProvider.borrowerDocument.getOne(filter: nil)
                .flatMap({ self._apiDataProvider.deleteDocument(model: DeleteDocumentApiModel(documentId: id, image: $0.documents[$0.documents.index(where: { $0.id == id })!].image!.deserialize())) })
                .flatMap({ _ in self._storageProvider.borrowerDocument.update(update: {
                        $0.documents.remove(at: $0.documents.index(where: { $0.id == id })!)
                        $0.isSentToReview = false
                    }, filter: nil).toObservable() })
    }
    
    // offers
    
    func getOffer(status: OfferStatus, skip: Int) -> Observable<[OfferApiModel]> {
        return _apiDataProvider.getOffer(status: status, skip: skip)
    }
    func aproveOffer(id: String) -> Observable<Bool> {
        return _apiDataProvider.aproveOffer(id: id)
    }
    func rejectOffer(id: String, message: String) -> Observable<Bool> {
        return _apiDataProvider.rejectOffer(model: RejectApiModel(offerId: id, rejectDescription: message))
    }
    func getCount() -> Observable<OfferCountApiModel> {
        return _apiDataProvider.getCount()
    }
    
    // fucn getProfile
    func getProfile() -> Observable<ProfileApiModel> {
        return _apiDataProvider.getProfile()
    }
    func updateProfile(data: UpdateProfileApiModel) -> Observable<Bool> {
        return _apiDataProvider.updateProfile(data: data)
    }
}
