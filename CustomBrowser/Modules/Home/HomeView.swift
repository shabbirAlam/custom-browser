//
//  HomeView.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var webStore: WebViewStore
    
    var body: some View {
        VStack {
            getHeaderView()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if webStore.isLoading {
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * webStore.progress, height: 2)
                        .animation(.easeOut(duration: 0.2), value: webStore.progress)
                }
                .frame(height: 2)
            }
            CustomWebView(store: webStore)
                .onAppear {
                    webStore.load(webStore.currentURL)
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
            
            TextField("Enter URL", text: $webStore.currentURL, onCommit: {
                webStore.load(webStore.currentURL)
            })
            .textFieldStyle(.roundedBorder)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
}
