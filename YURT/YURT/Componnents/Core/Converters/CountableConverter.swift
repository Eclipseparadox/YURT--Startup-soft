//
//  CountableConverter.swift
//  YURT
//
//  Created by Standret on 15.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class CountableConverter: SttConverterType {
    
    typealias TIn = (Int, String)
    typealias TOut = String
    
    func convert(value: (Int, String), parametr: Any?) -> String {
        return "\(value.0) \(value.1)\(value.0 == 1 ? "": "s")"
    }
}
