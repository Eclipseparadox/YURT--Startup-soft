//
//  DocumentsPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol DocumentsDelegate {
    
}

class DocumentsPresenter: SttPresenter<DocumentsDelegate> {
    var documents: ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])!
    
    override func presenterCreating() {
        documents =  ([[DocumentEntityPresenter]], [DocumentsEntityHeaderPresenter])([], [])
        documents.0.append([
            DocumentEntityPresenter(name: "Selfie"),
            DocumentEntityPresenter(name: "Your signature"),
            DocumentEntityPresenter(name: "Driver's license"),
            DocumentEntityPresenter(name: "Passport"),
            DocumentEntityPresenter(name: "Social Insurance Card (SIN)"),
            ])
        documents.0.append([
            DocumentEntityPresenter(name: "Void cheque"),
            DocumentEntityPresenter(name: "Tax assesments (2 years)"),
            DocumentEntityPresenter(name: "Current pay stub"),
            DocumentEntityPresenter(name: "Bank assesments"),
            DocumentEntityPresenter(name: "Utility bill"),
            ])
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Personal documents:", total: documents.0[0].count))
        documents.1.append(DocumentsEntityHeaderPresenter(title: "Financial documents:", total: documents.0[1].count))
    }
}
