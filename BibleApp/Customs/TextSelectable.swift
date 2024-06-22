//
//  TextSelectable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/19/24.
//

import SwiftUI
import SwiftData

struct TextSelectable: UIViewRepresentable {
    
    var text: NSAttributedString
    @Environment(\.modelContext) private var modelContext
    @Query private var arrayHighlights: [Highlight]
    var bibleId: String
    var chapterId: String
    
    init(text: NSAttributedString, bibleId: String, chapterId: String, modelContext: ModelContext) {
        self.text = text
        self.bibleId = bibleId
        self.chapterId = chapterId
        let predicate = #Predicate<Highlight> {
            $0.bibleId == bibleId && $0.chapterId == chapterId
        }
        _arrayHighlights = Query(filter: predicate)
    }
    
    func makeUIView(context: Context) -> CustomTextView {
        let textView = CustomTextView(arrayHighlights: arrayHighlights, bibleId: bibleId, chapterId: chapterId, modelContext: modelContext)
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: CustomTextView, context: Context) {
        uiView.attributedText = text
        uiView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        print("updateUIView = \(text)")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var text: NSAttributedString
        
        init(_ text: NSAttributedString) {
            self.text = text
            print("Coordinator init() = \(text)")
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("Coordinator textViewDidChange \(textView.attributedText)")
            self.text = textView.attributedText
        }
    }
}

class CustomTextView: UITextView {
    
    var arrayHighlights: [Highlight] = []
    var bibleId: String
    var chapterId: String
    var modelContext: ModelContext
    
    init(arrayHighlights: [Highlight], bibleId: String, chapterId: String, modelContext: ModelContext) {
        self.arrayHighlights = arrayHighlights
        self.bibleId = bibleId
        self.chapterId = chapterId
        self.modelContext = modelContext
        super.init(frame: .zero, textContainer: nil)
        print("CustomTextView init = \(text)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(highlightText) {
            return true
        }
        return false
    }
    
    override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let highlightTextAction = UIAction(title: "Highlight Passage") { action in
            self.highlightText()
        }
        let addNotesAction = UIAction(title: "Add Notes") { action in
            
        }
        let copyAction = UIAction(title: "Copy") { action in
            
        }
        let shareAction = UIAction(title: "Share") { action in
            
        }
        var actions = suggestedActions
        actions.insert(highlightTextAction, at: 0)
        actions.insert(addNotesAction, at: 1)
        actions.insert(copyAction, at: 2)
        actions.insert(shareAction, at: 3)
        return UIMenu(children: actions)
    }
    
    @objc func highlightText() {
        if let range = self.selectedTextRange, let selectedText = self.text(in: range) {
            let mutableString = NSMutableAttributedString.init(string: text)
            let highlight = Highlight(passage: selectedText, location: selectedRange.location, length: selectedRange.length, bibleId: bibleId, chapterId: chapterId)
            modelContext.insert(highlight)
            do {
                try modelContext.save()
            } catch {
                print("Passage highlight data error: \(error)")
            }
//            arrayHighlights.append(highlight)
            let highlightAttributes: [NSAttributedString.Key: Any] = [
                .backgroundColor: UIColor.orange,
                .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            ]
            let defaultFontAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            ]
            print("Highlights found: \(arrayHighlights.count)")
            for highlight in arrayHighlights {
                mutableString.addAttributes(highlightAttributes, range: highlight.getRange())
            }
            mutableString.addAttributes(defaultFontAttributes, range: NSRange(location: 0, length: text.count))
            attributedText = mutableString
        }
    }
}
