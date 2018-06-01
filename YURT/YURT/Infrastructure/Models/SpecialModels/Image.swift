//
//  Image.swift
//  YURT
//
//  Created by Standret on 31.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class Image {
    var data: Data?
    var url: String?
    
    init (data: Data) {
        self.data = data
    }
    
    init (url: String) {
        self.url = url
    }
}
