//
//  CountProgressConverter.swift
//  YURT
//
//  Created by Standret on 01.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class CountProgressConverter: SttConverterType {
    
    typealias TIn = (Int, Int)
    typealias TOut = String
    
    func convert(value: (Int, Int), parametr: Any?) -> String {
        return "\(value.0)/\(value.1)"
    }
}
