//
//  ViewController.swift
//  Easy Broswer
//
//  Created by wahid tariq on 20/08/21.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com","accuweather.com","github.com/wahidtariq"]
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton,spacer,refresh]
        navigationController?.isToolbarHidden = false
       
            let url = URL(string: "https://\(websites[0])")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true

    }
    
    @objc func openTapped(){
        
        let ac = UIAlertController(title: "open Page", message: nil, preferredStyle: .actionSheet)
        for website in websites{
        ac.addAction(UIAlertAction(title: website , style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true, completion: .none)
    
    }
    
    func openPage(action:UIAlertAction){
        guard let actionTitle = action.title else {return}
        
        guard let url = URL(string: "https://" + actionTitle) else {return}
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
           
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
            
        if let host = url?.host{
            for website in websites{
                if host.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
}
