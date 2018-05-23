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
    func uploadImage(image: UIImage) -> Observable<ResultUploadImageApiModel>
    func signUp(model: BorrowerSignUp) -> Observable<Bool>
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
    
    func uploadImage(image: UIImage) -> Observable<ResultUploadImageApiModel> {
        return _httpService.upload(controller: .upload("image"), data: UIImageJPEGRepresentation(image, 0.5)!, parameter: ["saveToTemporary" : "true"])
            .getResult(ofType: ResultUploadImageApiModel.self)
    }
    
    func signUp(model: BorrowerSignUp) -> Observable<Bool> {
        let data = model.getDictionary()
        return _httpService.post(controller: .mobileAccount("signup"), dataAny: data)
            .getResult()
    }
}
