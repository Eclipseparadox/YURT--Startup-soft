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
    
    func addDocument(model: AddDocumentApiModel) -> Observable<Bool>
}

class ApiService: IApiService {
  
    var _httpService: IHttpService!
    var _unitOfWork: IUnitOfWork!
    
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
    
    func addDocument(model: AddDocumentApiModel) -> Observable<Bool> {
        return _httpService.post(controller: .mobileDocument("add"), dataAny: model.getDictionary(), insertToken: true)
            .getResult()
    }
}
