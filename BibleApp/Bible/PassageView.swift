//
//  PassageView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI

struct PassageView: View {
    
    @EnvironmentObject private var bibleObservable: BibleObservable
    var bibleId: String
    var chapterId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    if let passage = bibleObservable.passage {
                        Text(LocalizedStringKey(passage.content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)))
                    }
                }
            }
            .navigationTitle("Passage")
            .padding(18)
            .task {
                do {
                    try await bibleObservable.getPassage(bibleId: bibleId, anyId: chapterId)
                } catch {
                    print(error)
                }
            }
        }
    }
}

//#Preview {
//    PassageView()
//}
