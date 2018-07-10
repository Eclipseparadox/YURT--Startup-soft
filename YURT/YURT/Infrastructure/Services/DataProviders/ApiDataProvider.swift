//
//  ApiService.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import KeychainSwift

protocol ApiDataProviderType {
    func inserToken(token: String)
    
    // account
    func emailExists(email: String) -> Observable<ExistModelString>
    
    // upload
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel>

    // token
    func signIn(email: String, password: String) -> Observable<AuthApiModel>
    
    // mobile/account
    func signUp(model: BorrowerSignUp) -> Observable<Bool>
    func externalLogin(token: String) -> Observable<AuthApiModel>
    
    // mobile/documents
    func getDocument() -> Observable<BorrowerDocumentModelApiModel>
    func addDocument(model: AddDocumentApiModel) -> Observable<BorrowerDocumentApiModel>
    func sendDocuments() -> Observable<Bool>
    func deleteDocument(model: DeleteDocumentApiModel) -> Observable<Bool>
    
    // mobile/offers
    func getOffer(status: OfferStatus, skip: Int) -> Observable<[OfferApiModel]>
    func aproveOffer(id: String) -> Observable<Bool>
    func rejectOffer(model: RejectApiModel) -> Observable<Bool>
    
    // mobile/profile
    func getProfile() -> Observable<ProfileApiModel>
    func updateProfile(data: UpdateProfileApiModel) -> Observable<Bool>
}

class ApiDataProvider: ApiDataProviderType {
  
    var _httpService: SttHttpServiceType!
    var _unitOfWork: StorageProviderType!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    func inserToken(token: String) {
        _httpService.token = token
    }
    
    // account
    func emailExists(email: String) -> Observable<ExistModelString> {
        return _httpService.get(controller: .account("emailexist"),
                                data: ["email": email])
            .getResult(ofType: ExistModelString.self)
    }
    func externalLogin(token: String) -> Observable<AuthApiModel> {
        return _httpService.get(controller: .mobileAccount("externallogin"), data: ["providerToken": token])
            .getResult(ofType: AuthApiModel.self)
    }
    
    // upload
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel> {
        return _httpService.upload(controller: .upload("image"),
                                   data: image.jpegRepresentation()!,
                                   parameter: ["saveToTemporary" : "true"],
                                   progresHandler: progresHandler)
            .getResult(ofType: ResultUploadImageApiModel.self)
    }
    
    // token
    func signIn(email: String, password: String) -> Observable<AuthApiModel> {
        let data = [
            "grant_type": "password",
            "userName": email,
            "password": password
        ]
        return _httpService.post(controller: .token, data: data)
            .getResult(ofType: AuthApiModel.self)
    }
    
    // mobile/account
    func signUp(model: BorrowerSignUp) -> Observable<Bool> {
        return _httpService.post(controller: .mobileAccount("signup"),
                                 data: model)
            .getResult()
    }
    
    // mobile/documents
    func addDocument(model: AddDocumentApiModel) -> Observable<BorrowerDocumentApiModel> {
        return _httpService.post(controller: .mobileDocument("add"), data: model, insertToken: true)
            .getResult(ofType: BorrowerDocumentApiModel.self)
    }
    func getDocument() -> Observable<BorrowerDocumentModelApiModel> {
        return _httpService.get(controller: .mobileDocument(""), insertToken: true)
                        .getResult(ofType: BorrowerDocumentModelApiModel.self)
    }
    func sendDocuments() -> Observable<Bool> {
        return _httpService.post(controller: .mobileDocument("send"), data: nil, insertToken: true) //_httpService.post(controller: .mobileDocument("send"), insertToken: true)
            .getResult()
    }
    func deleteDocument(model: DeleteDocumentApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .mobileDocument("delete"), data: model, insertToken: true)
            .getResult()
    }
    
    // mobile/offers
    func getOffer(status: OfferStatus, skip: Int) -> Observable<[OfferApiModel]> {
        return _httpService.get(controller: .mobileOffers(""), data: [
            "statuses": status.toString(),
            "skip": "\(skip)"
            ], insertToken: true)
            .getResult(ofType: [OfferApiModel].self)
    }
    func aproveOffer(id: String) -> Observable<Bool> {
        return _httpService.post(controller: .mobileOffers("approve"), data: id, insertToken: true)
                .getResult()
    }
    func rejectOffer(model: RejectApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .mobileOffers("reject"), data: model, insertToken: true)
                .getResult()
    }
    
    // mobile/profile
    func getProfile() -> Observable<ProfileApiModel> {
        return _httpService.get(controller: .mobileProfile(""), insertToken: true)
            .getResult(ofType: ProfileApiModel.self)
    }
    func updateProfile(data: UpdateProfileApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .mobileProfile("update"), data: data, insertToken: true)
            .getResult()
    }
}
