//
//  MainView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import SwiftUI

struct MainView: View {

    @StateObject private var bibleObservable = BibleObservable()

    var body: some View {
        NavigationStack {
            VStack {
                List(bibleObservable.arrayBibles) { bible in
                    Text(bible.name)
                }
            }
            .navigationTitle("Bibles")
        }
        .task {
            do {
//                try await bibl eObservable.getBibles(modelContext: <#ModelContext#>)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    MainView()
}
