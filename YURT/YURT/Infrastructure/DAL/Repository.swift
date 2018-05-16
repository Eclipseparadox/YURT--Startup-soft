//
//  Repository.swift
//  YURT
//
//  Created by Standret on 11.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol RealmCodable {
    associatedtype TTarget: BaseRealm, RealmDecodable
    
    func serialize() -> TTarget
}

protocol RealmDecodable {
    associatedtype TTarget
    
    func deserialize() -> TTarget
}

protocol IRepository {
    associatedtype TEntity: RealmCodable
    associatedtype TRealm: RealmDecodable
    
    init(singleton: Bool)
    
    func saveOne(model: TEntity) -> Observable<Bool>
    func saveMany(models: [TEntity]) -> Observable<Bool>
    
    func getOne(filter: String?) -> Observable<TEntity>
    func getMany(filter: String?) -> Observable<[TEntity]>
    
    func update(update: @escaping (_ dbObject: TRealm) -> Void, filter: String?) -> Observable<Bool>
    
    func delete(model: TEntity) -> Observable<Bool>
    func delete(filter: String?) -> Observable<Bool>
    
    func exists(filter: String?) -> Observable<Bool>
    func count(filter: String?) -> Observable<Int>
    //func save(model: TEntity)
    
}

class Repository<T, R>: IRepository
    where T: RealmCodable,
    R: RealmDecodable,
R: BaseRealm {
    
    typealias TEntity = T
    typealias TRealm = R
    
    private func getObjects<TArg>(filter: String?, observer: AnyObserver<TArg>, tryGetAll: Bool) throws -> Results<R> {
        let realm = try Realm()
        var objects: Results<R>!
        if let query = filter {
            if (self.singleton) {
                observer.onError(RealmError.objectIsSignleton)
            }
            else {
                objects = realm.objects(R.self).filter(query)
            }
        }
        else {
            if (!self.singleton && !tryGetAll) {
                observer.onError(RealmError.queryIsNull)
            }
            else {
                objects = realm.objects(R.self)
            }
        }
        return objects
    }
    
    private var singleton: Bool!
    
    required init(singleton: Bool) {
        self.singleton = singleton
    }
    
    func saveOne(model: T) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                if (self.singleton && realm.objects(R.self).count > 0) {
                    observer.onError(RealmError.objectIsSignleton)
                }
                realm.beginWrite()
                realm.add(model.serialize(), update: true)
                try realm.commitWrite()
                observer.onNext(true)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func saveMany(models: [T]) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            if (self.singleton) {
                observer.onError(RealmError.objectIsSignleton)
            }
            do {
                let realm = try Realm()
                realm.beginWrite()
                for item in models {
                    realm.add(item.serialize(), update: true)
                }
                try realm.commitWrite()
                observer.onNext(true)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func getOne(filter: String?) -> Observable<T> {
        return Observable<T>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: false)
                if (objects.count != 1) {
                    observer.onError(RealmError.doenotExactlyQuery)
                }
                else {
                    observer.onNext(objects[0].deserialize() as! T)
                }
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func getMany(filter: String?) -> Observable<[T]> {
        return Observable<[T]>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: true)
                if (objects.count == 1) {
                    observer.onError(RealmError.notFoundObjects)
                }
                else {
                    var results = [T]()
                    for item in objects {
                        results.append(item.deserialize() as! T)
                    }
                    observer.onNext(results)
                    observer.onCompleted()
                }
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    func update(update: @escaping (R) -> Void, filter: String?) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: false)
                if (objects.count != 1) {
                    observer.onError(RealmError.doenotExactlyQuery)
                }
                else {
                    try realm.write {
                        update(objects[0]) // check this method
                    }
                }
                observer.onNext(true)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    // check this method
    func delete(model: T) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(model.serialize())
                }
                observer.onNext(true)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func delete(filter: String?) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            do {
                let realm = try Realm()
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: true)
                
                if objects.count == 0 {
                    observer.onError(RealmError.notFoundObjects)
                }
                else {
                    try realm.write {
                        for item in objects {
                            realm.delete(item)
                        }
                    }
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func exists(filter: String?) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            do {
                let objects = try self.getObjects(filter: filter, observer: observer, tryGetAll: true)
                observer.onNext(objects.count > 0)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func count(filter: String?) -> Observable<Int> {
        return Observable<Int>.create { (observer) -> Disposable in
            if (self.singleton) {
                observer.onError(RealmError.objectIsSignleton)
                return Disposables.create()
            }
            do {
                let realm = try Realm()
                if let query = filter {
                    observer.onNext(realm.objects(R.self).filter(query).count)
                }
                else {
                    observer.onNext(realm.objects(R.self).count)
                }
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            
            return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
}
