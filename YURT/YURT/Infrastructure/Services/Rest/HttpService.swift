//
//  HttpService.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import KeychainSwift

protocol IHttpService {
    var url: String! { get set }
    var token: String { get set }
    var tokenType: String { get set }
    
    func get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, dataAny: [String:Any], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func upload(controller: ApiConroller, data: Data, parameter: [String:String], progresHandler: ((Float) -> Void)?) -> Observable<(HTTPURLResponse, Data)>
}

extension IHttpService {
    func get(controller: ApiConroller, data: [String:String] = [:], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.get(controller: controller, data: data, insertToken: insertToken)
    }
    func post(controller: ApiConroller, data: [String:String] = [:], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)> {
        return self.post(controller: controller, data: data, insertToken: insertToken)
    }
    func post(controller: ApiConroller, dataAny: [String:Any], insertToken: Bool = false) -> Observable<(HTTPURLResponse, Data)>{
        return self.post(controller: controller, dataAny: dataAny, insertToken: insertToken)
    }
}

class HttpService: IHttpService {
    
    var url: String!
    var token: String = ""
    var tokenType: String = ""
    var connectivity = Conectivity()
    
    init() {
        token = KeychainSwift().get(Constants.tokenKey) ?? ""
        tokenType = "bearer"
    }
    
    func  get(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            Log.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(BaseError.connectionError(ConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }
            return requestData(.get, url, parameters: data, encoding: URLEncoding.default,
                               headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:))
            }
            .configurateParamet()
    }
    
    
    func post(controller: ApiConroller, data: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            Log.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(BaseError.connectionError(ConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }
            return requestData(.post, url, parameters: data, encoding: URLEncoding.default,
                               headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:), onCompleted: nil, onDisposed: nil)
            }
            .configurateParamet()
    }
    
    func post(controller: ApiConroller, dataAny: [String:Any], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"
        var _insertToken = insertToken
        
        return Observable<(HTTPURLResponse, Data)>.create { (observer) -> Disposable in
            Log.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(BaseError.connectionError(ConnectionError.noInternetConnection))
                return Disposables.create()
            }
            
            if self.token == "" {
                _insertToken = false
            }

            return requestData(.post, url, parameters: dataAny, encoding: JSONEncoding.default,
                               headers: _insertToken ? ["Authorization" : "\(self.tokenType) \(self.token)"] : nil)
                .subscribe(onNext: { (res, data) in
                    observer.onNext((res, data))
                    observer.onCompleted()
                }, onError: observer.onError(_:), onCompleted: nil, onDisposed: nil)
            }
            .configurateParamet()
    }
    
    func upload(controller: ApiConroller, data: Data, parameter: [String:String], progresHandler: ((Float) -> Void)?) -> Observable<(HTTPURLResponse, Data)> {
        let url = "\(self.url!)\(controller.get())"

        return Observable<(HTTPURLResponse, Data)>.create( { observer in
            Log.trace(message: url, key: Constants.httpKeyLog)
            
            if !self.connectivity.isConnected {
                sleep(Constants.timeWaitNextRequest)
                observer.onError(BaseError.connectionError(ConnectionError.noInternetConnection))
                return Disposables.create()
            }

            Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: "file", fileName: "file.png", mimeType: "image/png")
                }, to: url, method: .put, headers: parameter,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.uploadProgress(closure: { (progress) in
                                if let handler = progresHandler {
                                    handler(Float(progress.fractionCompleted))
                                }
                            })
                            
                            upload.responseData(completionHandler: { (fullData) in
                                if upload.response != nil && fullData.data != nil {
                                    print("receive response")
                                    observer.onNext((upload.response!, fullData.data!))
                                    observer.onCompleted()
                                }
                                else {
                                    observer.onError(BaseError.apiError(ApiError.responseIsNi))
                                }
                            })
                        case .failure(let encodingError):
                            observer.onError(BaseError.unkown("\(encodingError)"))
                        }
            })
            return Disposables.create();
        })
            .do(onDispose: {
                print("on DisposeD")
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .timeout(180, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
}

extension Observable {
    func configurateParamet() -> Observable<Element> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .timeout(Constants.timeout, scheduler: MainScheduler.instance)
            .retry(Constants.maxCountRepeatRequest)
    }
}
