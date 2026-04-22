//
//  HistoryItem.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import Foundation

struct HistoryItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let url: URL
    let date: Date
}
