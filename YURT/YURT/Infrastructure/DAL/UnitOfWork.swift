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
}



class UnitOfWork: IUnitOfWork {
    
    private lazy var _auth = Repository<AuthApiModel, RealmAuth>  (singleton: true)

    
    var auth: Repository<AuthApiModel, RealmAuth> { return _auth }
}
