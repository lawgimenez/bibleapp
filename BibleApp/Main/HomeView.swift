//
//  HomeView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/16/24.
//

import SwiftUI
import Supabase

private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var authObservable: AuthObservable
    @StateObject private var highlightObservable = HighlightObservable()
    
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
                .environmentObject(authObservable)
        }
        .onAppear {
            highlightObservable.setModelContext(modelContext)
        }
        .task {
            do {
                let users: [UserDecodable] = try await client.from("User").select().eq("uuid", value: UserDefaults.standard.string(forKey: User.Key.uuid.rawValue)).execute().value
                if let user = users.first {
                    UserDefaults.standard.set(user.id, forKey: User.Key.id.rawValue)
                    UserDefaults.standard.set(user.uuid, forKey: User.Key.uuid.rawValue)
                    try await highlightObservable.getHighlights(userUuid: user.uuid)
                }
            } catch {
                print("Homeview error: \(error)")
            }
        }
    }
}

#Preview {
    HomeView()
}
