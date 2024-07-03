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
    var bibleId: String
    var chapterId: String
    
    init(text: NSAttributedString, bibleId: String, chapterId: String) {
        self.text = text
        self.bibleId = bibleId
        self.chapterId = chapterId
    }
    
    func makeUIView(context: Context) -> CustomTextView {
        let textView = CustomTextView(bibleId: bibleId, chapterId: chapterId)
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
    
    init(bibleId: String, chapterId: String) {
        self.bibleId = bibleId
        self.chapterId = chapterId
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
            let highlight = Highlight(id: 0, passage: selectedText, location: selectedRange.location, length: selectedRange.length, bibleId: bibleId, bibleName: "", chapterId: chapterId, chapterName: "", color: .highlightGrayish)
            let highlightDict = [
                "data": highlight
            ]
            NotificationCenter.default.post(name: Notification.Name("highlightAdded"), object: nil, userInfo: highlightDict)
        }
    }
}
