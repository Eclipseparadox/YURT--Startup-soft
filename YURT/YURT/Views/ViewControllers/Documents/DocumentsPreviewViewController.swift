//
//  DocumentsPreviewViewController.swift
//  YURT
//
//  Created by Standret on 26.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

class DocumentsPreviewViewController: SttViewController<DocumentPreviewPresenter>, DocumentPreviewDelegate, UIWebViewDelegate {
    
    @IBAction func close(_ sender: Any) {
        close()
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var mainIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        style = .lightContent
    }
        
    func insertData(fileUrl: String, name: String) {
        lblTitle.text = name
        if ["pdf", "doc", "docx"].contains(fileUrl.components(separatedBy: ".").last!.lowercased()) {
            if let url = URL(string: fileUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                webView!.loadRequest(URLRequest(url: url))
                mainIndicator.startAnimating()
            }
            else {
                self.sendError(error: DocumentsLoaderError.incorrectUrl)
            }
        }
        else {
            self.sendError(error: DocumentsLoaderError.unsupportedDocument(fileUrl.components(separatedBy: ".").last!.lowercased()))
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        mainIndicator.stopAnimating()
    }
}
