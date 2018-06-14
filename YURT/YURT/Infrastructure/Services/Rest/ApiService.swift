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

protocol IApiService {
    func inserToken(token: String)
    
    func emailExists(email: String) -> Observable<Bool>
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel>
    func signUp(model: BorrowerSignUp) -> Observable<Bool>
    func signIn(email: String, password: String) -> Observable<AuthApiModel>
    
    func getDocument() -> Observable<BorrowerDocumentModelApiModel>
    func addDocument(model: AddDocumentApiModel) -> Observable<BorrowerDocumentApiModel>
    func sendDocuments() -> Observable<Bool>
    func deleteDocument(model: DeleteDocumentApiModel) -> Observable<Bool>
}

class ApiService: IApiService {
  
    var _httpService: IHttpService!
    var _unitOfWork: StorageProviderType!
    
    init() {
        ServiceInjectorAssembly.instance().inject(into: self)
        _httpService.url = Constants.apiUrl
        _httpService.token = KeychainSwift().get(Constants.tokenKey) ?? ""
    }
    
    func inserToken(token: String) {
        _httpService.token = token
    }
    
    func emailExists(email: String) -> Observable<Bool> {
        return _httpService.get(controller: .account("emailexist"), data: ["email": email])
            .getResult(ofType: ExistModelString.self)
            .map { $0.isExist }
    }
    
    func uploadImage(image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<ResultUploadImageApiModel> {
        return _httpService.upload(controller: .upload("image"), data: image.jpegRepresentation()!, parameter: ["saveToTemporary" : "true"], progresHandler: progresHandler)
            .getResult(ofType: ResultUploadImageApiModel.self)
    }
    
    func signUp(model: BorrowerSignUp) -> Observable<Bool> {
        return _httpService.post(controller: .mobileAccount("signup"), dataAny: model.getDictionary())
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
        let localDoc = _unitOfWork.borrowerDocument.getOne(filter: nil)
                        .map({ $0.deserialize() })
        let apiData = _httpService.get(controller: .mobileDocument(""), insertToken: true)
                        .getResult(ofType: BorrowerDocumentModelApiModel.self)
                        .saveInDB(saveCallback: _unitOfWork.borrowerDocument.saveOne(model:))
        
        
        return Observable.merge([localDoc, apiData])
    }
    func sendDocuments() -> Observable<Bool> {
        return _httpService.post(controller: .mobileDocument("send"), insertToken: true)
            .getResult()
    }
    func deleteDocument(model: DeleteDocumentApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .mobileDocument("delete"), dataAny: model.getDictionary(), insertToken: true)
            .getResult()
    }
}
