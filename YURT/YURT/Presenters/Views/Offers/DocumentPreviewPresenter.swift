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
    func insertImage(image: UIImage)
}

class DocumentPreviewPresenter: SttPresenter<DocumentPreviewDelegate> {
    override func prepare(parametr: Any?) {
         delegate!.insertImage(image: parametr as! UIImage)
    }
}
