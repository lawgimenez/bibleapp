//
//  SettingsView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/26/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var authObservable: AuthObservable
    @State private var isSignOutAlertShown = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Account")) {
                    Text("Sign Out")
                        .alert("Sign Out", isPresented: $isSignOutAlertShown) {
                            Button(role: .destructive) {
                                do {
                                    try modelContext.delete(model: Item.self)
                                    try modelContext.delete(model: BibleData.self)
                                    try modelContext.delete(model: BookData.self)
                                    try modelContext.delete(model: ChapterData.self)
                                    try modelContext.delete(model: PassageData.self)
                                    try modelContext.delete(model: Highlight.self)
                                } catch {
                                    print("SwiftData model delete error: \(error)")
                                }
                                if let bundleIdentifier = Bundle.main.bundleIdentifier {
                                    UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
                                    UserDefaults.resetStandardUserDefaults()
                                    UserDefaults.standard.synchronize()
                                }
                                authObservable.signInStatus = .loggedOut
                            } label: {
                                Text("Sign Out")
                            }
                            Button(role: .cancel) {

                            } label: {
                                Text("Cancel")
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
