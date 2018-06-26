//
//  DocumentLenderCellPresenter.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol DocumentLenderCellDelegate {
    func insertImage(image: UIImage)
}

protocol DocumentLenderItemDelegate: class {
    func onClick(image: UIImage)
    func onError(error: SttBaseErrorType)
}

class DocumentLenderCellPresenter: SttPresenter<DocumentLenderCellDelegate> {
    var fileUrl: String!
    
    weak var itemDelegate: DocumentLenderItemDelegate?
    var isFinishLoading: Bool = false
    
    convenience init (url: String, delegate: DocumentLenderItemDelegate) {
        self.init()
        fileUrl = url
        itemDelegate = delegate
    }
    
    override func presenterCreating() {
        super.presenterCreating()
        
        _ = PdfLoader.loadPreviewImage(sringURL: fileUrl)
            .subscribe(onNext: { [weak self] (image) in
                self?.delegate?.insertImage(image: image)
                self?.isFinishLoading = true
            }, onError: { [weak self] (error) in
                self?.itemDelegate?.onError(error: error as! SttBaseErrorType)
            })
    }
    
    func onClick(image: UIImage) {
        itemDelegate?.onClick(image: image)
    }
}
