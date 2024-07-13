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
    @Environment(\.modelContext) private var modelContext
    @StateObject private var noteObservable = NoteObservable()

    var body: some View {
        NavigationStack {
            List(notes) { note in
                NotesRowView(note: note)
                    .swipeActions(edge: .trailing) {
                        Button {
                            Task {
                                try await noteObservable.deleteNote(note: note)
                            }
                        } label: {
                            Label("Delete Note", systemImage: "trash")
                                .tint(.red)
                        }
                    }
            }
            .navigationTitle("Notes")
        }
        .onAppear {
            noteObservable.setModelContext(modelContext)
        }
    }
}

#Preview {
    NotesView()
}
