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

protocol IUnitOfWork {
    var auth: Repository<AuthApiModel, RealmAuth> { get }
    var borrowerDocument: Repository<BorrowerDocumentApiModel, RealmBorrowerDocument> { get }
}



class UnitOfWork: IUnitOfWork {
    
    private lazy var _auth = Repository<AuthApiModel, RealmAuth>(singleton: true)
    private lazy var _borrowerDocument = Repository<BorrowerDocumentApiModel, RealmBorrowerDocument>(singleton: false)

    var auth: Repository<AuthApiModel, RealmAuth> { return _auth }
    var borrowerDocument: Repository<BorrowerDocumentApiModel, RealmBorrowerDocument> { return _borrowerDocument }
}
