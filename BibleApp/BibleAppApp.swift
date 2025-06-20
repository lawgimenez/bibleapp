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

    @StateObject private var authObservable = AuthObservable()

    var sharedModelContainer: ModelContainer = {
        UIColorValueTransformer.register()
        let schema = Schema([
            Item.self,
            BibleData.self,
            BookData.self,
            ChapterData.self,
            PassageData.self,
            Highlight.self,
            Note.self
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
            if authObservable.signInStatus == .success || authObservable.signUpStatus == .success {
                HomeView()
                    .environmentObject(authObservable)
            } else {
                SignInView()
                    .environmentObject(authObservable)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

extension UIColorValueTransformer {

    static let name = NSValueTransformerName(rawValue: String(describing: UIColorValueTransformer.self))

    public static func register() {
        let transformer = UIColorValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
