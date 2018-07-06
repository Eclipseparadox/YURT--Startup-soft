//
//  LinkedinLoginViewController.swift
//  YURT
//
//  Created by Standret on 05.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import RxAlamofire

class LinkedinLoginViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    var actIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: webView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: webView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: webView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: webView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            ])
        
        let data = SttDefaultComponnents.createBarButtonLoader()
        actIndicator = data.1
        actIndicator.color = UIColor.white
        actIndicator.startAnimating()
        navigationItem.setRightBarButton(data.0, animated: true)
        
        webView.navigationDelegate = self
        
        let ecodedDomain =  Constants.apiUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let lurl = "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=86z14ughq9lnnv&redirect_uri=\(ecodedDomain)&state=\(UUID().uuidString)&scope=r_basicprofile,r_emailaddress"
        let reuest = URLRequest(url: URL(string: lurl)!)
        _ = webView.load(reuest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let strUrl = "\(url)"
            let prefix = "\(Constants.apiUrl)?code="
            if strUrl.hasPrefix(prefix) {
                print("url: \(strUrl)")
                let startIndex = strUrl.index(strUrl.startIndex, offsetBy: prefix.count)
                let endIndex = strUrl.index(of: "&")
                print("token: \(strUrl[startIndex..<endIndex!])")
                _ = requestData(.post, URL(string: "https://www.linkedin.com/oauth/v2/accessToken")!,
                            parameters: [
                                "grant_type": "authorization_code",
                                "code": strUrl[startIndex..<endIndex!],
                                "redirect_uri": Constants.apiUrl,
                                "client_id": "86z14ughq9lnnv",
                                "client_secret": "tT4Rc3poR9dCrtLo"
                    ], encoding: URLEncoding.httpBody, headers: [:])
                    .subscribe(onNext: { (arg0) in
                        let (urlResponse, data) = arg0
                        print("---\nCode: \(urlResponse.statusCode)")
                        print(String(data: data, encoding: String.Encoding.utf8))
                        print("---")
                    }, onError: { print("error: \($0)") })
                
            }
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        actIndicator.stopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
