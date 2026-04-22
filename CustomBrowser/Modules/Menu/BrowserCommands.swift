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
            
            Divider()
            
            Button("Show Full History") {
                webStore.load(PageTypes.history.rawValue)
            }
            .keyboardShortcut("y", modifiers: .command)
        }
        
        CommandMenu("Bookmarks") {
            Button("Add Bookmark") {
                // Add bookmark
            }
            .keyboardShortcut("d", modifiers: .command)
            
            Divider()
            
//            ForEach(webStore.bookmark.prefix(10)) { item in
//                Button(item.title) {
//                    webStore.load(item.url)
//                }
//            }
//            
//            Divider()
//            
//            Button("Show All") {
//                // show all
//            }
        }
        
        CommandGroup(after: .help) {
            Button("Browser Help") {
                webStore.load("https://www.google.com/search?q=browser%20help")
            }
        }
    }
}
