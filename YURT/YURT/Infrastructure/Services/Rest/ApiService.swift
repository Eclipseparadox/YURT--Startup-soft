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
    
    
}
