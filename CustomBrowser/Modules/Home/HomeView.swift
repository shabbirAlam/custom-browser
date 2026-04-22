//
//  HomeView.swift
//  CustomBrowser
//
//  Created by Md Shabbir Alam on 22/04/26.
//

import SwiftUI

struct HomeView: View {
    let url = URL(string: "https://www.google.com")
    
    var body: some View {
        VStack {
            getHeaderView()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let url {
                CustomWebView(url: url)
            }
        }
        .padding()
    }
    
    func getHeaderView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "arrow.left")
            }
            
            Button {
                
            } label: {
                Image(systemName: "arrow.right")
            }
            
            Button {
                
            } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
}

#Preview {
    HomeView()
}
