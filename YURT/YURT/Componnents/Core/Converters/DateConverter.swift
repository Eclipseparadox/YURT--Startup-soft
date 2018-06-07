//
//  DateConverter.swift
//  YURT
//
//  Created by Standret on 31.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class DateConverter: ConverterType {
    
    typealias TIn = Date
    typealias TOut = String
    
    func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM-dd-yyyy"
        
        return formatter.string(from: value)
    }
}
