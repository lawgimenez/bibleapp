//
//  BibleView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI
import SwiftData

struct BibleView: View {

    @Environment(\.modelContext) private var modelContext
    @StateObject private var bibleObservable = BibleObservable()
    @Query(sort: \BibleData.name) private var bibles: [BibleData]

    var body: some View {
        NavigationStack {
            VStack {
                List(bibles) { bible in
                    NavigationLink {
                        BooksView(bible: bible)
                            .environmentObject(bibleObservable)
                    } label: {
                        VStack {
                            Text(bible.name)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Bibles")
        }
        .task {
            do {
                try await bibleObservable.getBibles(modelContext: modelContext)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    BibleView()
}
