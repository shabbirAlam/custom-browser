//
//  HistoryView.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var webStore: WebViewStore
    
    var body: some View {
        VStack {
            if webStore.history.isEmpty {
                Text("No History")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(webStore.history) { item in
                        Button {
                            webStore.load(item.url)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline)
                                
                                Text(item.url.absoluteString)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text(item.date, style: .date)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Clear All") {
                    webStore.history.removeAll()
                }
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        webStore.history.remove(atOffsets: offsets)
    }
}
