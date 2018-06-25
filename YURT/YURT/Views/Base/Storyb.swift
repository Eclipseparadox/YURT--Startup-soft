//
//  SttViewController.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit

enum Storyboard: String, SttStoryboardType {
    
    case main = "Main"
    case photo = "Photo"
    case offer = "Offer"
    case login = "Login"
    
    func getName() -> String {
        return self.rawValue
    }
}
