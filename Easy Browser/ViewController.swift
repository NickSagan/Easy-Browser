//
//  ViewController.swift
//  Easy Browser
//
//  Created by Nick Sagan on 24.10.2021.
//

import UIKit

// we need this to use WKWebView etc.
import WebKit

// Don't forget WKNavigationDelegate protocol
class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    // Safe list of web sites
    var websites = ["google.com", "apple.com", "mail.ru"]
    
    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        
        // ViewController's view become a browser
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser"
        
        // adds "open" nav bar item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // adds "refresh" bar button
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // adds progress view
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton, spacer, backButton, forwardButton, refresh]
        
        // shows toolbar at bottom
        navigationController?.isToolbarHidden = false
        
        // adds observer to see website's loading progress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Starting page
        let url = URL(string: "https://\(websites[0])")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        
        // Create an instance of alert controller
        let ac = UIAlertController(title: "Open page:", message: nil, preferredStyle: .actionSheet)
        
        // Add our safe-list sites
        for site in websites {
            ac.addAction(UIAlertAction(title: site, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Uncomments this line if you use Ipad
//        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        // launch alert controller
        present(ac, animated: true)
    }
    
    // load page with url
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    // Update Nav title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = "Easy Browser: " + "\(webView.title ?? "")"
    }
    
    // Adds KVO (key value observer) for estimatedProgress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            // update progressView
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    // Delete this func if dont want any resrictions
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // set url to be equal navigation url
        let url = navigationAction.request.url
        
        // unwrap url's host
        if let host = url?.host {
            // check if it is on our safe list
            for website in websites {
                if host.contains(website){
                    // allow loading
                    decisionHandler(.allow)
                    return
                }
            }
        }
        // else cancel loading
        
        title = "BLOCKED!!!"
        decisionHandler(.cancel)
    }
    
}

