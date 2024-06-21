//
//  ChapterView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI
import SwiftData

struct ChapterView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var bibleObservable: BibleObservable
    @Query private var chapters: [ChapterData]
    var bibleId: String
    var bookId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                List(chapters) { chapter in
                    NavigationLink {
                        PassageView(bibleId: bibleId, chapterId: chapter.id)
                            .environmentObject(bibleObservable)
                    } label: {
                        Text(chapter.reference)
                    }
                }
            }
            .task {
                do {
                    try await bibleObservable.getChapter(bibleId: bibleId, bookId: bookId, modelContext: modelContext)
                } catch {
                    print(error)
                }
            }
        }
    }
}

//#Preview {
//    ChapterView()
//}
