//
//  BrowserCommands.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI

struct BrowserCommands: Commands {
    @ObservedObject var webStore: WebViewStore
    
    var body: some Commands {
        CommandMenu("History") {
            Button("Home") {
                webStore.goToHome()
            }
            .keyboardShortcut("h", modifiers: [.command, .shift])
            
            Button("Back") {
                webStore.goBack()
            }
            .keyboardShortcut("[", modifiers: .command)
            
            Button("Forward") {
                webStore.goForward()
            }
            .keyboardShortcut("]", modifiers: .command)
            
            Divider()
            
            ForEach(webStore.history.prefix(10)) { item in
                Button(item.title) {
                    webStore.load(item.url)
                }
            }
            
            Divider()
            
            Button("Clear History") {
                webStore.history.removeAll()
                webStore.goToHome()
            }
        }
    }
}
