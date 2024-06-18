//
//  BooksView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI

struct BooksView: View {
    
    @EnvironmentObject private var bibleObservable: BibleObservable
    var bible: Bible.Data
    
    var body: some View {
        NavigationStack {
            VStack {
                List(bibleObservable.arrayBooks) { book in
                    NavigationLink {
                        SectionView(bibleId: bible.id, bookId: book.id)
                            .environmentObject(bibleObservable)
                    } label: {
                        Text(book.name)
                    }
                }
            }
            .task {
                do {
                    try await bibleObservable.getBooks(bibleId: bible.id)
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
