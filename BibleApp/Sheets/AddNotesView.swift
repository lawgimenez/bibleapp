//
//  AddNotesView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/3/24.
//

import SwiftUI
import MarkdownUI

struct AddNotesView: View {
    
    var note: Note
    
    var body: some View {
        NavigationStack {
            VStack {
                Markdown("> \(note.passage)")
                    .markdownTheme(.gitHub)
                Spacer()
            }
            .padding()
            .navigationTitle("Add Notes")
        }
    }
}

//#Preview {
//    AddNotesView()
//}
