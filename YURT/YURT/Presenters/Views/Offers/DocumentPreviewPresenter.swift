//
//  DocumentPreviewPresenter.swift
//  YURT
//
//  Created by Standret on 26.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

protocol DocumentPreviewDelegate {
    func insertData(fileUrl: String, name: String)
}

class DocumentPreviewPresenter: SttPresenter<DocumentPreviewDelegate> {
    override func prepare(parametr: Any?) {
        let param = parametr as! (String, String)
        delegate?.insertData(fileUrl: param.0, name: param.1)
    }
}
