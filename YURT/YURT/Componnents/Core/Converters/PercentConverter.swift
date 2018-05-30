//
//  PercentConverter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class PercentConverter: ConverterType {
    
    typealias TIn = Float
    typealias TOut = String
    
    func convert(value: Float, parametr: Any?) -> String {
        return "\(Int(value * 100))%"
    }
}
