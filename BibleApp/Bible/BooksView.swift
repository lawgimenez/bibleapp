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
    @State private var books = [BookData]()
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
                if let books = getBooks(bibleId: bible.id) {
                    self.books = books
                }
            }
            .navigationTitle(bible.name)
        }
    }

    private func getBooks(bibleId: String) -> [BookData]? {
        let predicate = #Predicate<BookData> {
            $0.bibleId == bibleId
        }
        let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.name)])
        do {
            let books = try modelContext.fetch(fetchDescriptor)
            return books
        } catch {
            print("Books fetch error: \(error)")
            return nil
        }
    }
}

// #Preview {
//    BooksView()
// }
