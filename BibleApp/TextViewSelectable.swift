//
//  TextViewSelectable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/19/24.
//

import SwiftUI

struct TextViewSelectable: UIViewRepresentable {
    
    let textView = UITextView()
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        print("Text is \(text)")
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            _text.wrappedValue = textView.text
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            print(textView.selectedRange)
        }
    }
}
