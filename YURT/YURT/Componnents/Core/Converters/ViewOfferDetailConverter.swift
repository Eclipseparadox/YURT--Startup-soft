//
//  ViewOfferDetailConverter.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class ViewOfferDetailConverter: ConverterType {
    
    typealias TIn = (Double, OfferDetailType)
    typealias TOut = String
    
    func convert(value: (Double, OfferDetailType), parametr: Any?) -> String {
        switch value.1 {
        case .count: return "\(Int(value.0))"
        case .currency: return "$ \(Int(value.0).formattedWithSeparator)"
        case .days: return CountableConverter().convert(value: (Int(value.0), "day"))
        case .percent: return "\(value.0)%"
        case .years: return CountableConverter().convert(value: (Int(value.0), "year"))
        }
    }
}
