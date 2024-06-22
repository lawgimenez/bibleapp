//
//  PassageView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI
import SwiftData
import SelectableText

struct PassageView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var bibleObservable: BibleObservable
    @Query private var passage: [PassageData]
    @State private var selectedRange: NSRange?
    @State private var textHeight: CGFloat = 300
    @State private var passageAttributed = NSAttributedString(string: "")
    @State private var textStyle = UIFont.TextStyle.body
    @State private var arrayHighlights = [Highlight]()
    var bibleId: String
    var chapterId: String
    
    init(bibleId: String, chapterId: String) {
        self.bibleId = bibleId
        self.chapterId = chapterId
        let predicate = #Predicate<PassageData> {
            $0.bibleId == bibleId && $0.chapterId == chapterId
        }
        _passage = Query(filter: predicate)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextSelectable(text: passageAttributed, bibleId: bibleId, chapterId: chapterId, modelContext: modelContext)
            }
            .onChange(of: bibleObservable.passageContent) {
                if let passageData = passage.first {
                    let passageData = passageData.content.data(using: .unicode)
                    let attributedPassageData = try? NSAttributedString(data: passageData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                    passageAttributed = attributedPassageData!
                }
            }
            .background(Color.red)
            .navigationTitle("Passage")
            .padding(18)
            .task {
                do {
                    try await bibleObservable.getPassage(bibleId: bibleId, anyId: chapterId, modelContext: modelContext)
                } catch {
                    print(error)
                }
                if let passageData = passage.first {
                    let passageData = passageData.content.data(using: .unicode)
                    let attributedPassageData = try? NSAttributedString(data: passageData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                    passageAttributed = attributedPassageData!
                }
                print("Lawx: Passage bookID: \(bibleId)")
                print("Lawx: Passage chapterID: \(chapterId)")
            }
        }
    }
}

//#Preview {
//    PassageView()
//}
