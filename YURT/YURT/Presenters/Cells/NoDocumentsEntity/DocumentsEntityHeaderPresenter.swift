//
//  DocumentsEntityHeaderPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift

protocol DocumentsEntityHeaderDelegate {
    
}

class DocumentsEntityHeaderPresenter: SttPresenter<DocumentsEntityHeaderDelegate> {
    
    var title: String!
    var uploadedsCount: Int = 0
    var isError: Bool?
    var totalCountDocument: Int!
    
    convenience init (title: String, total: Int, observable: Observable<(Bool, DocumentType)>) {
        self.init()
        self.title = title
        self.totalCountDocument = total
        _ = observable.takeWhile( { arg in arg.1.isFinancies() } ).subscribe(onNext: { [weak self] (arg) in
            if let _self = self {
                if arg.0 && _self.uploadedsCount < _self.totalCountDocument {
                    _self.uploadedsCount += 1
                }
                else if _self.uploadedsCount > 0 {
                    _self.uploadedsCount -= 1
                }
            }
        })
    }
}
