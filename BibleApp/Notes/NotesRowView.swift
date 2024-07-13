//
//  NotesRowView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/4/24.
//

import SwiftUI
import MarkdownUI

struct NotesRowView: View {
    
    var note: Note
    @State private var passage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Markdown {
                "> \(passage)"
            }
            .markdownTheme(.gitHub)
            Divider()
            Text(note.userNote)
                .padding()
            HStack {
                Image(systemName: "book.circle")
                Text(note.bibleName)
            }
            Spacer()
        }
        .onAppear {
            passage = formatQuote(passage: note.passage)
        }
        .padding()
    }
    
    private func formatQuote(passage: String) -> String {
        let formattedQuote = passage.replacingOccurrences(of: "\n\n", with: " \n\n> ")
        return formattedQuote
    }
}

//#Preview {
//    NotesRowView()
//}
