//
//  HomeView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/16/24.
//

import SwiftUI

struct HomeView: View {
    
    enum Pages: String {
        case bible
        case highlights
        case notes
        case profile
    }
    
    @State private var selectedTab: Pages = .bible
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BibleView()
                .tabItem {
                    Label(Pages.bible.rawValue.capitalized, systemImage: "book")
                }
                .tag(Pages.bible)
        }
    }
}

#Preview {
    HomeView()
}
