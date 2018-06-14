//
//  UnitOfWork.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxRealm
import RxSwift

protocol StorageProviderType {
    var auth: Repository<AuthApiModel, RealmAuth> { get }
    var borrowerDocument: Repository<BorrowerDocumentModelApiModel, RealmBorrowerDocumentModel> { get }
}

class RealmStorageProvider: StorageProviderType {
    
    private lazy var _auth = Repository<AuthApiModel, RealmAuth>(singleton: true)
    private lazy var _borrowerDocument = Repository<BorrowerDocumentModelApiModel, RealmBorrowerDocumentModel>(singleton: true)

    var auth: Repository<AuthApiModel, RealmAuth> { return _auth }
    var borrowerDocument: Repository<BorrowerDocumentModelApiModel, RealmBorrowerDocumentModel> { return _borrowerDocument }
}
