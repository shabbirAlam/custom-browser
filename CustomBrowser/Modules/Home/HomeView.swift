//
//  HomeView.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var webStore = WebViewStore()
    @State private var urlText: String = ""
    
    var body: some View {
        VStack {
            getHeaderView()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CustomWebView(store: webStore)
                .onAppear {
                    webStore.load(urlText)
                }
                .onReceive(webStore.$currentURL) { newURL in
                    urlText = newURL
                }
            
        }
        .padding()
    }
    
    func getHeaderView() -> some View {
        HStack {
            Button {
                webStore.goBack()
            } label: {
                Image(systemName: "arrow.left")
            }
            .disabled(!webStore.canGoBack)
            .opacity(webStore.canGoBack ? 1 : 0.8)
            
            Button {
                webStore.goForward()
            } label: {
                Image(systemName: "arrow.right")
            }
            .disabled(!webStore.canGoForward)
            .opacity(webStore.canGoForward ? 1 : 0.8)
            
            Button {
                webStore.reload()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            
            TextField("Enter URL", text: $urlText, onCommit: {
                webStore.load(urlText)
            })
            .textFieldStyle(.roundedBorder)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
}
