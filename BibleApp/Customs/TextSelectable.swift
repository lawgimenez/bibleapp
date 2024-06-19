//
//  TextSelectable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/19/24.
//

import SwiftUI

struct TextSelectable: UIViewRepresentable {
    
//    @Binding var height: CGFloat
    @Binding var text: NSAttributedString
    @Binding var textStyle: UIFont.TextStyle
    var selectedRange: NSRange?
    var onSelectedRangeChanged: ((NSRange?) -> Void)?
    
    func makeUIView(context: Context) -> CustomTextView {
        let textView = CustomTextView()
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: CustomTextView, context: Context) {
//        uiView.text = text
        uiView.attributedText = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
//        if uiView.selectedRange != selectedRange {
//            uiView.selectedRange = selectedRange ?? NSRange(location: 0, length: 0)
//        }
//        DispatchQueue.main.async {
//            height = uiView.intrinsicContentSize.height
//        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<NSAttributedString>
        
        init(_ text: Binding<NSAttributedString>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.attributedText
        }
    }
}

class CustomTextView: UITextView {
    
//    var maxLayoutWidth: CGFloat = 0 {
//        didSet {
//            guard maxLayoutWidth != oldValue else { return }
//            
//            invalidateIntrinsicContentSize()
//        }
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        guard maxLayoutWidth > 0 else {
//            return super.intrinsicContentSize
//        }
//        
//        return sizeThatFits(
//            CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude)
//        )
//    }
    
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
        var actions = suggestedActions
        actions.insert(highlightTextAction, at: 0)
        return UIMenu(children: actions)
    }
    
    @objc func highlightText() {
        if let range = self.selectedTextRange, let selectedText = self.text(in: range) {
            print("Selected text is \(selectedText)")
        }
    }
}
