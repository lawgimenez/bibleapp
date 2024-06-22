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
    
    @State private var highlightsColor = [
        Highlights(color: .highlightPink),
        Highlights(color: .highlightGreen),
        Highlights(color: .highlightGrayish),
        Highlights(color: .highlightLightBlue)
    ]
    
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
    @State private var isPresentHighlightOptions = false
    @State private var selectedColor = Highlights(color: .highlightPink)
    @State private var addedHighlight = false
    @State private var highlight: Highlight?
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
            .onChange(of: addedHighlight) {
                if addedHighlight {
                    if let highlight {
                        // Update highlight color value to one selected by user
                        highlight.color = selectedColor.color
                        modelContext.insert(highlight)
                        do {
                            try modelContext.save()
                        } catch {
                            print("Passage highlight data error: \(error)")
                        }
                    }
                    passageAttributed = addHighlights(text: passageAttributed.string)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("highlightAdded"))) { output in
                print("Highlight updated")
                if let highlight = output.userInfo!["data"] as? Highlight {
                    print("Highlight object found: \(highlight)")
                    self.highlight = highlight
                    isPresentHighlightOptions = true
                }
                passageAttributed = addHighlights(text: passageAttributed.string)
            }
            .sheet(isPresented: $isPresentHighlightOptions) {
                HighlightOptionView(highlightsColor: $highlightsColor, selectedColor: $selectedColor, addedHighlight: $addedHighlight)
                    .presentationDetents([.height(300)])
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
        let mutableString = NSMutableAttributedString.init(string: text)
        for highlight in highlights {
            print("Highlight is = \(highlight.getRange())")
            let highlightAttributes: [NSAttributedString.Key: Any] = [
                .backgroundColor: highlight.uiColor,
                .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            ]
            mutableString.addAttributes(highlightAttributes, range: highlight.getRange())
        }
        return mutableString
    }
}

//#Preview {
//    PassageView()
//}
