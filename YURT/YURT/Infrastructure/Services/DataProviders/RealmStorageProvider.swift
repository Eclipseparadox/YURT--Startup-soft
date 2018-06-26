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
    var auth: SttRepository<AuthApiModel, RealmAuth> { get }
    var borrowerDocument: SttRepository<BorrowerDocumentModelApiModel, RealmBorrowerDocumentModel> { get }
}

class RealmStorageProvider: StorageProviderType {
    
    private lazy var _auth = SttRepository<AuthApiModel, RealmAuth>(singleton: true)
    private lazy var _borrowerDocument = SttRepository<BorrowerDocumentModelApiModel, RealmBorrowerDocumentModel>(singleton: true)

    var auth: SttRepository<AuthApiModel, RealmAuth> { return _auth }
    var borrowerDocument: SttRepository<BorrowerDocumentModelApiModel, RealmBorrowerDocumentModel> { return _borrowerDocument }
}
