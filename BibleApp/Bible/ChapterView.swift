//
//  ChapterView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI

struct ChapterView: View {
    
    @EnvironmentObject private var bibleObservable: BibleObservable
    var bibleId: String
    var bookId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                List(bibleObservable.arrayChapters) { chapter in
                    VStack {
                        Text(chapter.number)
                        Text(chapter.reference)
                    }
                }
            }
            .task {
                do {
                    try await bibleObservable.getChapter(bibleId: bibleId, bookId: bookId)
                } catch {
                    print(error)
                }
            }
            .navigationTitle("Chapters")
        }
    }
}

//#Preview {
//    ChapterView()
//}
