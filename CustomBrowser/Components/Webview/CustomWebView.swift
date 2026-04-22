//
//  WebView.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI
import WebKit

struct CustomWebView: NSViewRepresentable {
    @ObservedObject var store: WebViewStore
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = store.webView
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
        
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        // Avoid unnecessary reloads
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        
        var parent: CustomWebView
        
        init(_ parent: CustomWebView) {
            self.parent = parent
        }
        
        // MARK: - Navigation Lifecycle
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Start loading:", webView.url?.absoluteString ?? "")
            parent.store.currentURL = webView.url?.absoluteString ?? ""
            parent.store.isLoading = true
            parent.store.progress = 0.1
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("Content started arriving")
            parent.store.canGoBack = webView.canGoBack
            parent.store.canGoForward = webView.canGoForward
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading:", webView.url?.absoluteString ?? "")
            
            parent.store.currentURL = webView.url?.absoluteString ?? ""
            parent.store.progress = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.parent.store.isLoading = false
                self?.parent.store.progress = 0
            }
            
            parent.store.addToHistory(
                title: webView.title,
                url: webView.url)
            parent.store.canGoBack = webView.canGoBack
            parent.store.canGoForward = webView.canGoForward
        }
        // MARK: - Navigation Decision
        
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if let url = navigationAction.request.url {
                print("Requesting:", url.absoluteString)
            }
            
            decisionHandler(.allow)
        }
        
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            if let response = navigationResponse.response as? HTTPURLResponse {
                print("Response status:", response.statusCode)
            }
            
            decisionHandler(.allow)
        }
        
        // MARK: - Errors
        
        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            print("Navigation error:", error.localizedDescription)
        }
        
        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            print("Provisional error:", error.localizedDescription)
        }
        
        // MARK: - Redirect
        
        func webView(
            _ webView: WKWebView,
            didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!
        ) {
            print("Redirected to:", webView.url?.absoluteString ?? "")
        }
        
        // MARK: - Authentication (HTTPS / login)
        
        func webView(
            _ webView: WKWebView,
            didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        ) {
            print("Auth challenge:", challenge.protectionSpace.host)
            
            completionHandler(.performDefaultHandling, nil)
        }
        
        // MARK: - UI Delegate (alerts, popups)
        
        func webView(
            _ webView: WKWebView,
            runJavaScriptAlertPanelWithMessage message: String,
            initiatedByFrame frame: WKFrameInfo,
            completionHandler: @escaping () -> Void
        ) {
            print("JS Alert:", message)
            completionHandler()
        }
        
        func webView(
            _ webView: WKWebView,
            createWebViewWith configuration: WKWebViewConfiguration,
            for navigationAction: WKNavigationAction,
            windowFeatures: WKWindowFeatures
        ) -> WKWebView? {
            print("New window requested")
            return nil // block popups or handle manually
        }
        
        func webViewDidClose(_ webView: WKWebView) {
            print("WebView closed")
        }
    }
}
