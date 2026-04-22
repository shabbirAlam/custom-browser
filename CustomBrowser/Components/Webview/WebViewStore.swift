//
//  WebViewStore.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import Combine
import WebKit
import SwiftUI

final class WebViewStore: NSObject, ObservableObject {
    let webView: WKWebView
    
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var currentURL: String = "https://www.google.com"
    @Published var progress: Double = 0.0
    @Published var isLoading: Bool = false
    
    override init() {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        super.init()
        
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "canGoBack")
        webView.removeObserver(self, forKeyPath: "canGoForward")
        webView.removeObserver(self, forKeyPath: "URL")
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        DispatchQueue.main.async {
            self.canGoBack = self.webView.canGoBack
            self.canGoForward = self.webView.canGoForward
            self.currentURL = self.webView.url?.absoluteString ?? ""
        }
    }
    
    // MARK: - Actions
    
    func load(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func load(_ string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // If contains space → search
        if trimmed.contains(" ") {
            searchOnGoogle(trimmed)
            return
        }
        
        // Better domain detection
        let isValidDomain = isLikelyDomain(trimmed)
        
        if isValidDomain {
            var urlString = trimmed
            
            if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                urlString = "https://" + urlString
            }
            
            if let url = URL(string: urlString) {
                load(url)
                return
            }
        }
        
        // Fallback → search
        searchOnGoogle(trimmed)
    }
    
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func reload() {
        webView.reload()
    }
}

private extension WebViewStore {
    func isLikelyDomain(_ text: String) -> Bool {
        // must contain dot AND valid TLD (like .com, .org)
        let parts = text.split(separator: ".")
        
        guard parts.count >= 2 else { return false }
        
        // last part (TLD) should be alphabetic and >= 2 chars
        if let last = parts.last,
           last.count >= 2,
           last.allSatisfy({ $0.isLetter }) {
            return true
        }
        
        if text.contains(":") {
            return true
        }
        
        return false
    }
    
    func searchOnGoogle(_ query: String) {
        let allowed = CharacterSet.urlQueryAllowed
        let encoded = query.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        
        let urlString = "https://www.google.com/search?q=\(encoded)"
        
        guard let url = URL(string: urlString) else { return }
        
        load(url)
    }
}
