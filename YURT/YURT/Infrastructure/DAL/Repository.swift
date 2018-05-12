//
//  Repository.swift
//  YURT
//
//  Created by Standret on 11.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol RealmCodable {
    func serialize()
}

protocol RealmDecodable {
    func deserialize()
}

protocol IRepository {
    associatedtype TEntity: RealmCodable, RealmDecodable
    
    func save(model: TEntity)
    
}

class Repository<T>: IRepository
    where T: RealmCodable, T: RealmDecodable {
    
    typealias TEntity = T
    
    func save(model: T) {
        
    }
}
