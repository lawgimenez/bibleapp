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
                        let passageData = passage.content.data(using: .unicode)
                        let attributedPassageData = try? NSAttributedString(data: passageData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                        Text(AttributedString(attributedPassageData!))
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
