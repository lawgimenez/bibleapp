//
//  SectionView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI

struct SectionView: View {
    
    @EnvironmentObject private var bibleObservable: BibleObservable
    var bibleId: String
    var bookId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                List(bibleObservable.arraySections) { section in
                    Text(section.title)
                }
            }
            .task {
                do {
                    try await bibleObservable.getSections(bibleId: bibleId, bookId: bookId)
                } catch {
                    print(error)
                }
            }
            .navigationTitle("Sections")
        }
    }
}

//#Preview {
//    ChapterView()
//}
