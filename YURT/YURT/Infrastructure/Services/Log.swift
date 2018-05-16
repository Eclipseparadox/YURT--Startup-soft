//
//  Log.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class Log {
    class func trace(message: String, key: String) {
        print("TRACE in \(key): \(message)")
    }
    class func error(message: String, key: String) {
        print ("ERROR in \(key): \(message)")
    }
}
