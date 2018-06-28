//
//  ProfileViewController.swift
//  YURT
//
//  Created by Standret on 05.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import KeychainSwift
import RealmSwift
import RxSwift

enum DocumentsLoaderError: Error, SttBaseErrorType {
    
    case unsupportedDocument(String)
    case incorrectUrl
    
    func getMessage() -> (String, String) {
        var message: (String, String)!
        switch self {
        case .incorrectUrl:
            message = ("urlIsNill", "")
        case .unsupportedDocument(let mess):
            message = ("unsupportedDocumentType", "of type: \(mess)")
        }
        return message
    }
}

class DocumentsPreviewImageLoader: NSObject, UIWebViewDelegate {
    
    private var webView: UIWebView?
    
    private var publisher = PublishSubject<UIImage?>()
    var observable: Observable<UIImage?> { return publisher }
    
    func load(fileURLString: String) {
        if ["pdf", "doc", "docx"].contains(fileURLString.components(separatedBy: ".").last!.lowercased()) {
            if let url = URL(string: fileURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                webView = UIWebView(frame: CGRect(x: 20, y: 20, width: 500, height: 666))
                webView?.delegate = self
                webView!.loadRequest(URLRequest(url: url))
            }
            else {
                publisher.onError(DocumentsLoaderError.incorrectUrl)
            }
        }
        else {
            publisher.onError(DocumentsLoaderError.unsupportedDocument(fileURLString.components(separatedBy: ".").last!.lowercased()))
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIGraphicsBeginImageContext(CGSize(width: 500, height: 666))
        let context = UIGraphicsGetCurrentContext()
        webView.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        publisher.onNext(image)
        publisher.onCompleted()
        publisher.dispose()
    }
}

class ProfileViewController: SttViewController<ProfilePresenter>, ProfileDelegate {
    
    @IBOutlet weak var img: UIImageView!
    var webView: UIWebView = UIWebView(frame: CGRect(x: 20, y: 20, width: 500, height: 666))
    @IBAction func exit(_ sender: Any) {
        KeychainSwift().delete(Constants.tokenKey)
        let realm = try! Realm()
        
        loadStoryboard(storyboard: Storyboard.login)
    }
    
    var loader: DocumentsPreviewImageLoader!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader = DocumentsPreviewImageLoader()
        _ = loader.observable.subscribe(onNext: { (image) in
            self.img.image = image
        })
        loader.load(fileURLString: "https://calibre-ebook.com/downloads/demos/demo.docx")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
