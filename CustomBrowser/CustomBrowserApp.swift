//
//  CustomBrowserApp.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI

@main
struct CustomBrowserApp: App {
    @StateObject private var webStore = WebViewStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(webStore)
        }
        .commands {
            BrowserCommands(webStore: webStore)
        }
    }
}
