//
//  PassageView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI
import SelectableText

struct PassageView: View {
    
    @EnvironmentObject private var bibleObservable: BibleObservable
    @State private var selectedRange: NSRange?
    @State private var textHeight: CGFloat = 300
    @State private var passage = NSAttributedString(string: "")
    @State private var textStyle = UIFont.TextStyle.body
    var bibleId: String
    var chapterId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                TextSelectable(text: $passage, textStyle: $textStyle)
            }
            .onChange(of: bibleObservable.passageContent) {
                let passageData = bibleObservable.passageContent.data(using: .unicode)
                let attributedPassageData = try? NSAttributedString(data: passageData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                passage = attributedPassageData!
            }
            .background(Color.red)
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
