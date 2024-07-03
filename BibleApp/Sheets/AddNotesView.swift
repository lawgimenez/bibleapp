//
//  AddNotesView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/3/24.
//

import SwiftUI
import MarkdownUI

struct AddNotesView: View {
    
    @Environment(\.dismiss) private var dismiss
    var note: Note
    
    var body: some View {
        NavigationStack {
            VStack {
                Markdown("> \(note.passage)")
                    .markdownTheme(.gitHub)
                Divider()
                Spacer()
            }
            .toolbar {
                let cancelPlacement: ToolbarItemPlacement = .topBarLeading
                ToolbarItem(placement: cancelPlacement) {
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                }
                let savePlacement: ToolbarItemPlacement = .topBarTrailing
                ToolbarItem(placement: savePlacement) {
                    Button {
//                        dismiss()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .navigationTitle("Add Notes")
        }
    }
}

//#Preview {
//    AddNotesView()
//}
