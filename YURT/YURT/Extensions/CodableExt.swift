//
//  CodableExt.swift
//  YURT
//
//  Created by Piter Standret on 6/4/18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol DictionaryCodable: Codable { }

extension DictionaryCodable {
    func getDictionary() -> [String:Any] {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let json = (try encoder.encode(self))
            print(String(data: json, encoding: .utf8)!)
            let jsonData = String(data: json, encoding: .utf8)?.data(using: .utf8)
            return (try JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves) as? [String:Any])!
        }
        catch {
            return [:]
        }
    }
}
