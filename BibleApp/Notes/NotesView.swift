//
//  NotesView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/24/24.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    
    @Query private var notes: [Note]
    
    var body: some View {
        NavigationStack {
            List(notes) { note in
                NotesRowView(note: note)
                    .listRowBackground(note.color)
            }
            .navigationTitle("Notes")
        }
    }
}

#Preview {
    NotesView()
}
