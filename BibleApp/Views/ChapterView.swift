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
    @State private var chapters = [ChapterData]()
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
                if let chapters = getChapters(bibleId: bibleId, bookId: bookId) {
                    self.chapters = chapters
                }
            }
            .navigationTitle("Chapters")
        }
    }

    private func getChapters(bibleId: String, bookId: String) -> [ChapterData]? {
        let predicate = #Predicate<ChapterData> {
            $0.bibleId == bibleId && $0.bookId == bookId
        }
        let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.number)])
        do {
            let chapters = try modelContext.fetch(fetchDescriptor)
            return chapters
        } catch {
            print("Books fetch error: \(error)")
            return nil
        }
    }
}

// #Preview {
//    ChapterView()
// }
