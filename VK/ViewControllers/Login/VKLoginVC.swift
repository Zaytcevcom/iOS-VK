//
//  VKLoginVC.swift
//  VK
//
//  Created by Konstantin Zaytcev on 04.04.2022.
//

import UIKit
import WebKit

final class VKLoginVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    private var urlComponents: URLComponents = {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "oauth.vk.com"
        comp.path = "/authorize"
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: "8126825"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        return comp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let url = urlComponents.url
        else {
            return
        }
        webView.load(URLRequest(url: url))
    }
}

extension VKLoginVC: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            return decisionHandler(.allow)
            
        }
            
        let parameters = fragment
            .components(separatedBy: "&")
            .map{$0.components(separatedBy: "=")}
            .reduce([String: String]()) { partialResult, params in
                var dict = partialResult
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
            }
        
        guard
            let token = parameters["access_token"],
            let userIDString = parameters["user_id"],
            let userID = Int(userIDString)
        else {
            return decisionHandler(.allow)
        }
            
        SomeSingleton.instance.token = token
        SomeSingleton.instance.userId = userID
            
        performSegue(withIdentifier: "toMain", sender: nil)
            
        decisionHandler(.cancel)
                    
    }
    
}
