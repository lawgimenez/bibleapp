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
        case settings
    }
    
    @State private var selectedTab: Pages = .bible
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BibleView()
                .tabItem {
                    Label(Pages.bible.rawValue.capitalized, systemImage: "book")
                }
                .tag(Pages.bible)
            HighlightsView()
                .tabItem {
                    Label(Pages.highlights.rawValue.capitalized, systemImage: "highlighter")
                }
                .tag(Pages.highlights)
            NotesView()
                .tabItem {
                    Label(Pages.notes.rawValue.capitalized, systemImage: "note")
                }
                .tag(Pages.notes)
            SettingsView()
                .tabItem {
                    Label(Pages.settings.rawValue.capitalized, systemImage: "gear")
                }
                .tag(Pages.settings)
        }
    }
}

#Preview {
    HomeView()
}
