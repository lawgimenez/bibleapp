//
//  TextSelectable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/19/24.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct TextSelectable: UIViewRepresentable {

    var text: NSAttributedString
    var bibleId: String
    var chapterId: String

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
            print("TextSelectable: textViewDidChange")
            self.text = textView.attributedText
        }
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            print("TextSelectable textViewShouldBeginEditing")
            return false
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            print("TextSelectable textViewDidChangeSelection")
            textView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textTapped(_:))))
        }
        
        @objc private func textTapped(_ sender: UITapGestureRecognizer) {
            print("TextSelectable: textTapped called")
            let textView = sender.view as! CustomTextView
            let layoutManger = textView.layoutManager
            // Location of the tap
            var location = sender.location(in: textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            // Character index at tap location
            let characterIndex = layoutManger.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            // If index is valid
            if characterIndex < textView.textStorage.length {
//                print("TextSelectable tap valid, index = \(characterIndex)")
//                print("TextSelectable tap length: \(textView.textStorage.length)")
//                let attributeValue = textView.attributedText.attribute(.backgroundColor, at: characterIndex, effectiveRange: nil) as? String
                let attributes = textView.attributedText.attributes(at: characterIndex, effectiveRange: nil)
                if let backgroundColor = attributes[.backgroundColor] as? UIColor {
                    // Determine is this is a highlight or note
                    if let highlight = attributes[.highlight] as? Highlight {
                        textView.noteToDelete(note: nil)
                        textView.highlightToDelete(highlight: highlight)
                    } else if let note = attributes[.note] as? Note {
                        textView.highlightToDelete(highlight: nil)
                        textView.noteToDelete(note: note)
                    }
                    textView.setIsDestructive(isDestructive: true)
                } else {
                    print("No highlights found")
                    textView.setIsDestructive(isDestructive: false)
                }
                textView.layoutIfNeeded()
            }
        }
    }
}

class CustomTextView: UITextView {

    var bibleId: String
    var chapterId: String
    private var isDestructive = false
    private var highlight: Highlight? = nil
    private var note: Note? = nil

    init(bibleId: String, chapterId: String) {
        self.bibleId = bibleId
        self.chapterId = chapterId
        super.init(frame: .zero, textContainer: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if isDestructive {
            if action == #selector(deleteHighlightText) {
                return true
            } else if action == #selector(deleteNotes) {
                return true
            }
        } else {
            if action == #selector(highlightText) {
                return true
            } else if action == #selector(addNotes) {
                return true
            } else if action == #selector(copyToClipboard) {
                return true
            }
        }
        return false
    }

    override func editMenu(for textRange: UITextRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        if isDestructive {
            var actions = suggestedActions
            if let highlight {
                let deleteHighlightTextAction = UIAction(title: "Delete Highlight") { _ in
                    self.deleteHighlightText()
                }
                actions.insert(deleteHighlightTextAction, at: 0)
            }
            if let note {
                let deleteNotesAction = UIAction(title: "Delete Notes") { _ in
                    self.deleteNotes()
                }
                actions.insert(deleteNotesAction, at: 0)
            }
            return UIMenu(children: actions)
        } else {
            let highlightTextAction = UIAction(title: "Highlight Passage") { _ in
                self.highlightText()
            }
            let addNotesAction = UIAction(title: "Add Notes") { _ in
                self.addNotes()
            }
            let copyAction = UIAction(title: "Copy") { _ in
                self.copyToClipboard()
            }
            let shareAction = UIAction(title: "Share") { _ in

            }
            var actions = suggestedActions
            actions.insert(highlightTextAction, at: 0)
            actions.insert(addNotesAction, at: 1)
            actions.insert(copyAction, at: 2)
            actions.insert(shareAction, at: 3)
            return UIMenu(children: actions)
        }
    }

    @objc private func highlightText() {
        if let range = self.selectedTextRange, let selectedText = self.text(in: range) {
            let highlight = Highlight(id: 0, passage: selectedText, location: selectedRange.location, length: selectedRange.length, bibleId: bibleId, bibleName: "", chapterId: chapterId, chapterName: "", color: .highlightGrayish)
            let highlightDict = [
                "data": highlight
            ]
            NotificationCenter.default.post(name: Notification.Name("highlightAdded"), object: nil, userInfo: highlightDict)
        }
    }
    
    @objc private func deleteHighlightText() {
        if let highlight {
            let highlightDict = [
                "data": highlight
            ]
            NotificationCenter.default.post(name: Notification.Name("deleteHighlight"), object: nil, userInfo: highlightDict)
        }
    }
    
    @objc private func deleteNotes() {
        if let note {
            let highlightDict = [
                "data": note
            ]
            NotificationCenter.default.post(name: Notification.Name("deleteNote"), object: nil, userInfo: highlightDict)
        }
    }
    
    @objc private func addNotes() {
        if let range = self.selectedTextRange, let selectedText = self.text(in: range) {
            let note = Note(id: 0, passage: selectedText, userNote: "", location: selectedRange.location, length: selectedRange.length, bibleId: bibleId, bibleName: "", chapterId: chapterId, chapterName: "", color: .highlightGrayish)
            let noteDict = [
                "data": note
            ]
            NotificationCenter.default.post(name: Notification.Name("addNote"), object: nil, userInfo: noteDict)
        }
    }
    
    @objc private func copyToClipboard() {
        if let range = self.selectedTextRange, let selectedText = self.text(in: range) {
            UIPasteboard.general.setValue(selectedText, forPasteboardType: UTType.plainText.identifier)
        }
    }
    
    func setIsDestructive(isDestructive: Bool) {
        print("Is destructive: \(isDestructive)")
        self.isDestructive = isDestructive
    }
    
    func highlightToDelete(highlight: Highlight?) {
        self.highlight = highlight
    }
    
    func noteToDelete(note: Note?) {
        self.note = note
    }
}
