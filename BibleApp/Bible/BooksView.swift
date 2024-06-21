//
//  BooksView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI
import SwiftData

struct BooksView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var bibleObservable: BibleObservable
    @Query private var books: [BookData]
    var bible: BibleData
    
    var body: some View {
        NavigationStack {
            VStack {
                List(books) { book in
                    NavigationLink {
                        ChapterView(bibleId: bible.id, bookId: book.id)
                            .environmentObject(bibleObservable)
                    } label: {
                        Text(book.name)
                    }
                }
            }
            .task {
                do {
                    try await bibleObservable.getBooks(bibleId: bible.id, modelContext: modelContext)
                } catch {
                    print(error)
                }
            }
            .navigationTitle(bible.name)
        }
    }
}

//#Preview {
//    BooksView()
//}
