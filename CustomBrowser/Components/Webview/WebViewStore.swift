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
    static var defaultURL: String {
        "https://www.google.com"
    }
    
    let webView: WKWebView
    
    @Published var history: [HistoryItem] = []
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var currentURL: String = defaultURL
    @Published var progress: Double = 0.0
    @Published var isLoading: Bool = false
    
    override init() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X)"
        super.init()
    }
}

// MARK: - Actions
extension WebViewStore {
    func load(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func load(_ string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        
//        // Internal routes (like chrome://)
//        if trimmed == "browser://history" {
//            currentPage = .history
//            return
//        }
//        
//        if trimmed == "browser://home" {
//            currentPage = .home
//            return
//        }
        
        // If contains space → search
        if trimmed.contains(" ") {
            search(trimmed)
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
        search(trimmed)
    }
    
    func goToHome() {
        load(Self.defaultURL)
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

// MARK: - Helper methods
extension WebViewStore {
    func addToHistory(title: String?, url: URL?) {
        guard let url else { return }
        
        let item = HistoryItem(
            title: title ?? url.absoluteString,
            url: url,
            date: Date()
        )
        history.insert(item, at: 0)
    }
}

private extension WebViewStore {
    func isLikelyDomain(_ text: String) -> Bool {
        // must contain dot
        let parts = text.split(separator: ".")
        
        guard parts.count >= 2 else { return false }
        
        // last part should be alphabetic and >= 2 chars
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
    
    func search(_ query: String) {
        let allowed = CharacterSet.urlQueryAllowed
        let encoded = query.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        
        let urlString = "\(Self.defaultURL)/search?q=\(encoded)"
        
        guard let url = URL(string: urlString) else { return }
        
        load(url)
    }
}
