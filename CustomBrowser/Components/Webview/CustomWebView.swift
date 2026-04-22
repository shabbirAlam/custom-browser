//
//  WebView.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI
import WebKit

struct CustomWebView: NSViewRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        webView.allowsBackForwardNavigationGestures = true
        
        webView.load(URLRequest(url: url))
        
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
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("Content started arriving")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading:", webView.url?.absoluteString ?? "")
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
