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
    func insertImage(image: UIImage?)
}

protocol DocumentLenderItemDelegate: class {
    func onClick(url: String, fileName: String)
    func onError(error: SttBaseErrorType)
}

class DocumentLenderCellPresenter: SttPresenter<DocumentLenderCellDelegate> {
    var fileUrl: String!
    
    weak var itemDelegate: DocumentLenderItemDelegate?
    var isFinishLoading: Bool = false
    
    var loader: DocumentsPreviewImageLoader!
    var disposable: Disposable?
    
    convenience init (url: String, delegate: DocumentLenderItemDelegate) {
        self.init()
        fileUrl = url
        itemDelegate = delegate
    }
    
    override func presenterCreating() {
        super.presenterCreating()
        
        disposable?.dispose()
        if fileUrl.components(separatedBy: ".").last! == "pdf" {
            _ = PdfLoader.loadPreviewImage(stringURL: fileUrl)
                .subscribe(onNext: { [weak self] (image) in
                    self?.delegate?.insertImage(image: image)
                    self?.isFinishLoading = true
                    }, onError: { [weak self] (error) in
                        self?.itemDelegate?.onError(error: error as! SttBaseErrorType)
                })
        }
        else
        {
            loader = DocumentsPreviewImageLoader()
            disposable = loader.observable
                .subscribe(onNext: { [weak self] (image) in
                    self?.delegate?.insertImage(image: image)
                    self?.isFinishLoading = true
                }, onError: { [weak self] (error) in
                    self?.itemDelegate?.onError(error: error as! SttBaseErrorType)
                })
            loader.load(fileURLString: fileUrl)
        }
    }
    
    func onClick(image: UIImage) {
        itemDelegate?.onClick(url: fileUrl, fileName: fileUrl.components(separatedBy: "/").last!)
    }
}
