//
//  AuthViewController.swift
//  SpotifySample
//
//  Created by anies1212 on 2022/04/02.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManagaer.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    ///Exchange the code to access token.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {return}
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else {return}
        webView.isHidden = true
        AuthManagaer.shared.exchangeCodeForToken(code: code) {[weak self] success in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                strongSelf.navigationController?.popToRootViewController(animated: true)
                strongSelf.completionHandler?(success)
            }
        }
    }
    
    
    



}
