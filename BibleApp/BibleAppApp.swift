//
//  BibleAppApp.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import SwiftUI
import SwiftData

@main
struct BibleAppApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            BibleData.self,
            BookData.self,
            ChapterData.self,
            PassageData.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            BibleView()
        }
        .modelContainer(sharedModelContainer)
    }
}
