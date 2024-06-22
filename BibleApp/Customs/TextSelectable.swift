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
    var bibleId: String
    var chapterId: String
    
    init(text: NSAttributedString, bibleId: String, chapterId: String, modelContext: ModelContext) {
        self.text = text
        self.bibleId = bibleId
        self.chapterId = chapterId
    }
    
    func makeUIView(context: Context) -> CustomTextView {
        let textView = CustomTextView(bibleId: bibleId, chapterId: chapterId, modelContext: modelContext)
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
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var text: NSAttributedString
        
        init(_ text: NSAttributedString) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.attributedText
        }
    }
}

class CustomTextView: UITextView {
    
    var bibleId: String
    var chapterId: String
    var modelContext: ModelContext
    
    init(bibleId: String, chapterId: String, modelContext: ModelContext) {
        self.bibleId = bibleId
        self.chapterId = chapterId
        self.modelContext = modelContext
        super.init(frame: .zero, textContainer: nil)
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
            let highlight = Highlight(passage: selectedText, location: selectedRange.location, length: selectedRange.length, bibleId: bibleId, chapterId: chapterId, color: .highlightGrayish)
            
            let mutableString = NSMutableAttributedString.init(string: text)
//            modelContext.insert(highlight)
//            do {
//                try modelContext.save()
//            } catch {
//                print("Passage highlight data error: \(error)")
//            }
            
//            let highlightAttributes: [NSAttributedString.Key: Any] = [
//                .backgroundColor: UIColor.orange,
//                .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
//            ]
//            let defaultFontAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
//            ]
//            mutableString.addAttributes(highlightAttributes, range: highlight.getRange())
//            mutableString.addAttributes(defaultFontAttributes, range: NSRange(location: 0, length: text.count))
//            attributedText = mutableString
            let highlightDict = [
                "data": highlight
            ]
            NotificationCenter.default.post(name: Notification.Name("highlightAdded"), object: nil, userInfo: highlightDict)
        }
    }
}
