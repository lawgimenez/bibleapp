//
//  VerseView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI

struct VerseView: View {
    
    @EnvironmentObject private var bibleObservable: BibleObservable
    var bibleId: String
    var verseId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .task {
                do {
                    try await bibleObservable.getVerse(bibleId: bibleId, verseId: verseId)
                } catch {
                    print(error)
                }
            }
        }
    }
}

//#Preview {
//    VerseView()
//}
