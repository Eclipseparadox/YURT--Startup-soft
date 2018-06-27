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
    
    func emailExists(email: String) -> Observable<ExistModelString>
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel>
    func signUp(model: BorrowerSignUp) -> Observable<Bool>
    func signIn(email: String, password: String) -> Observable<AuthApiModel>
    
    func getDocument() -> Observable<BorrowerDocumentModelApiModel>
    func addDocument(model: AddDocumentApiModel) -> Observable<BorrowerDocumentApiModel>
    func sendDocuments() -> Observable<Bool>
    func deleteDocument(model: DeleteDocumentApiModel) -> Observable<Bool>
    
    func getOffer(status: OfferStatus, skip: Int) -> Observable<[OfferApiModel]>
    func aproveOffer(id: String) -> Observable<Bool>
    func rejectOffer(model: RejectApiModel) -> Observable<Bool>
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
    
    func emailExists(email: String) -> Observable<ExistModelString> {
        return _httpService.get(controller: .account("emailexist"),
                                data: ["email": email])
            .getResult(ofType: ExistModelString.self)
    }
    
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel> {
        return _httpService.upload(controller: .upload("image"),
                                   data: image.jpegRepresentation()!,
                                   parameter: ["saveToTemporary" : "true"],
                                   progresHandler: progresHandler)
            .getResult(ofType: ResultUploadImageApiModel.self)
    }
    
    func signUp(model: BorrowerSignUp) -> Observable<Bool> {
        return _httpService.post(controller: .mobileAccount("signup"),
                                 dataAny: model.getDictionary())
            .getResult()
    }
    func signIn(email: String, password: String) -> Observable<AuthApiModel> {
        let data = [
            "grant_type": "password",
            "userName": email,
            "password": password
        ]
        return _httpService.post(controller: .token, data: data)
            .getResult(ofType: AuthApiModel.self)
    }
    
    func addDocument(model: AddDocumentApiModel) -> Observable<BorrowerDocumentApiModel> {
        return _httpService.post(controller: .mobileDocument("add"), dataAny: model.getDictionary(), insertToken: true)
            .getResult(ofType: BorrowerDocumentApiModel.self)
    }
    func getDocument() -> Observable<BorrowerDocumentModelApiModel> {
        return _httpService.get(controller: .mobileDocument(""), insertToken: true)
                        .getResult(ofType: BorrowerDocumentModelApiModel.self)
    }
    func sendDocuments() -> Observable<Bool> {
        return _httpService.post(controller: .mobileDocument("send"), insertToken: true)
            .getResult()
    }
    func deleteDocument(model: DeleteDocumentApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .mobileDocument("delete"), dataAny: model.getDictionary(), insertToken: true)
            .getResult()
    }
    
    func getOffer(status: OfferStatus, skip: Int) -> Observable<[OfferApiModel]> {
        return _httpService.get(controller: .mobileOffers(""), data: [
            "statuses": status.toString(),
            "skip": "\(skip)"
            ], insertToken: true)
            .getResult(ofType: [OfferApiModel].self)
    }
    func aproveOffer(id: String) -> Observable<Bool> {
        return _httpService.post(controller: .mobileOffers("approve"), data: ["id": id], insertToken: true)
                .getResult()
    }
    func rejectOffer(model: RejectApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .mobileOffers("reject"), dataAny: model.getDictionary(), insertToken: true)
                .getResult()
    }
}
