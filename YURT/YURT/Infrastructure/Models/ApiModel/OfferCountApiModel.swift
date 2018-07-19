//
//  OfferCountApiModel.swift
//  YURT
//
//  Created by Standret on 18.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct OfferCountApiModel: Decodable {
    let allNewOffersCount: Int
    let allApprovedOffersCount: Int
    let allRejectedOffersCount: Int
}
