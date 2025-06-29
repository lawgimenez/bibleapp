//
//  AddNotesView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/3/24.
//

import SwiftUI
import MarkdownUI
import Supabase
import SwiftData

private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)

struct AddNotesView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var noteObservable: NoteObservable
    @State private var userNote = ""
    @State private var passage = ""
    @Binding var isPresentAddNotesOptions: Bool
    @Binding var addedNote: Bool
    var note: Note
    var modelContext: ModelContext

    var body: some View {
        NavigationStack {
            VStack {
                Markdown("> \(passage)")
                    .markdownTheme(.gitHub)
                Divider()
                TextField("Add your notes here...", text: $userNote, axis: .vertical)
                    .autocorrectionDisabled(true)
                    .padding()
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
                        if !userNote.isEmpty {
                            saveNote()
                        }
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .onAppear {
                passage = note.passage
            }
            .onChange(of: noteObservable.addNoteStatus) {
                if noteObservable.addNoteStatus == .success {
                    Task {
                        modelContext.insert(note)
                        try modelContext.save()
                    }
                    noteObservable.addNoteStatus = .none
                    addedNote = true
                    isPresentAddNotesOptions = false
                }
            }
            .padding()
            .navigationTitle("Add Notes")
        }
    }

    private func saveNote() {
        Task {
            // Construct note model
            let noteEncodable = NoteEncodable(passage: note.passage, userNote: $userNote.wrappedValue, color: note.uiColor.hexString, length: note.length, location: note.location, bibleId: note.bibleId, bibleName: note.bibleName, chapterId: note.chapterId, chapterName: note.chapterName, userUuid: UserDefaults.standard.string(forKey: User.Key.uuid.rawValue)!)
            do {
                try await noteObservable.saveNote(noteEncodable: noteEncodable)
                noteObservable.addNoteStatus = .success
            } catch {
                print("Save note error: \(error)")
            }
        }
    }
}

// #Preview {
//    AddNotesView()
// }
