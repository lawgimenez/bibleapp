//
//  NotesRowView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/4/24.
//

import SwiftUI

struct NotesRowView: View {
    
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.passage)
            Spacer()
            HStack {
                Image(systemName: "book.circle")
                Text(note.bibleName)
            }
        }
    }
}

//#Preview {
//    NotesRowView()
//}
