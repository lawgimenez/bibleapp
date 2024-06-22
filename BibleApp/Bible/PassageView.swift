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
    @Query private var highlights: [Highlight]
    @State private var selectedRange: NSRange?
    @State private var textHeight: CGFloat = 300
    @State private var passageAttributed = NSAttributedString(string: "")
    @State private var textStyle = UIFont.TextStyle.body
    @State private var arrayHighlights = [Highlight]()
    @State private var highlightAdded = false
    var bibleId: String
    var chapterId: String
    
    init(bibleId: String, chapterId: String) {
        self.bibleId = bibleId
        self.chapterId = chapterId
        let predicate = #Predicate<PassageData> {
            $0.bibleId == bibleId && $0.chapterId == chapterId
        }
        _passage = Query(filter: predicate)
        let highlightPredicate = #Predicate<Highlight> {
            $0.bibleId == bibleId && $0.chapterId == chapterId
        }
        _highlights = Query(filter: highlightPredicate)
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
//                    passageAttributed = addHighlights(text: attributedPassageData!.string)
                    passageAttributed = attributedPassageData!
                }
            }
            .onChange(of: passageAttributed) {
                passageAttributed = addHighlights(text: passageAttributed.string)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("highlightAdded"))) { _ in
                print("Highlight updated")
                passageAttributed = addHighlights(text: passageAttributed.string)
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
    
    private func addHighlights(text: String) -> NSAttributedString {
        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .backgroundColor: UIColor.orange,
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        ]
        let mutableString = NSMutableAttributedString.init(string: text)
        for highlight in highlights {
            print("Highlight is = \(highlight.getRange())")
            mutableString.addAttributes(highlightAttributes, range: highlight.getRange())
        }
        return mutableString
    }
}

//#Preview {
//    PassageView()
//}
