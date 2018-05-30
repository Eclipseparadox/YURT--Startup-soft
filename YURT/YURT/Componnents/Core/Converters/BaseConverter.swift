//
//  BaseConverter.swift
//  YURT
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol ConverterType {
    associatedtype TIn
    associatedtype TOut
    
    func convert(value: TIn, parametr: Any?) -> TOut
}

extension ConverterType {
    func convert(value: TIn) -> TOut {
        return self.convert(value: value, parametr: nil)
    }
}
