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
    @State private var textHeight: CGFloat = .zero
    var bibleId: String
    var chapterId: String
    
    var body: some View {
        NavigationStack {
            VStack {
                //ScrollView(showsIndicators: false) {
                    if let passage = bibleObservable.passage {
                        let passageData = passage.content.data(using: .unicode)
                        let attributedPassageData = try? NSAttributedString(data: passageData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//                        SelectableText(attributedPassageData!)
//                        Text(AttributedString(attributedPassageData!))
                        passageText(passage.content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil), selectedRange: $selectedRange, textHeight: $textHeight).frame(width: .infinity, height: 300)
                        
                    //}
//                    TextViewSelectable(text: $passageText)
                }
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
    
    private func passageText(_ content: String, selectedRange: Binding<NSRange?>, textHeight: Binding<CGFloat>) -> some View {
        print("content = \(content)")
        var selectedRange: NSRange?
        let text = TextSelectable(height: textHeight, text: content, selectedRange: selectedRange) { range in
            selectedRange = range
        }
        return text
    }
}

//#Preview {
//    PassageView()
//}
