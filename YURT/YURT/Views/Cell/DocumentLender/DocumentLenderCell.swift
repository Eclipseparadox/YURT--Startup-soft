//
//  DocumentLenderCell.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import Foundation
import RxSwift

enum PdfLoaderError: Error, SttBaseErrorType {
    
    case documetIsNil
    case pageIsNil
    case unsupportedDocument(String)
    case urlIsNil
    
    func getMessage() -> (String, String) {
        var message: (String, String)!
        switch self {
        case .urlIsNil:
            message = ("urlIsNill", "")
        case .unsupportedDocument(let mess):
            message = ("unsupportedDocumentType", "of type: \(mess)")
        case .documetIsNil:
            message = ("documetIsNil", "")
        case .pageIsNil:
            message = ("pageIsNil", "")
        }
        
        return message
    }
}

class PdfLoader {
    class func loadPreviewImage(stringURL: String) -> Observable<UIImage> {
        return Observable<UIImage>.create({ (observer) -> Disposable in
            if ["pdf"].contains(stringURL.components(separatedBy: ".").last!.lowercased()) {
                if let url = URL(string: stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                    if let documents = CGPDFDocument(url as CFURL) {
                        if let page = documents.page(at: 1) {
                            let pageRect = page.getBoxRect(.mediaBox)
                            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                            let img = renderer.image { ctx in
                                UIColor.white.set()
                                ctx.fill(pageRect)
                                
                                ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                                
                                ctx.cgContext.drawPDFPage(page)
                            }
                            
                            observer.onNext(img)
                            observer.onCompleted()
                        }
                        else {
                            observer.onError(PdfLoaderError.pageIsNil)
                        }
                    }
                    else {
                        observer.onError(PdfLoaderError.documetIsNil)
                    }
                }
                else {
                    observer.onError(PdfLoaderError.urlIsNil)
                }
            }
            else {
                observer.onError(PdfLoaderError.unsupportedDocument(stringURL.components(separatedBy: ".").last!))
            }
            
            return Disposables.create()
        })
        .inBackground()
        .observeInUI()
        
    }
}

class DocumentLenderCell: SttCollectionViewCell<DocumentLenderCellPresenter>, DocumentLenderCellDelegate {

    @IBOutlet weak var imgDocuments: UIImageView!
    
    override func prepareBind() {
        super.prepareBind()
    
    }
    
    @objc private func onClick(_ sender: Any) {
        presenter.onClick(image: imgDocuments.image!)
    }
    
    func insertImage(image: UIImage?) {
        imgDocuments.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 2
        self.setBorder(color: UIColor(named: "border")!, size: 1)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }
}
