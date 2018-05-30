//
//  Defaultable.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol Defaultable {
    init()
}

class FactoryDefaultsObject {
    class func create<T: Defaultable>(ofType _: T.Type) -> T {
        return T()
    }
}
