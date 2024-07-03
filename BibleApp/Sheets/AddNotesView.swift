//
//  AddNotesView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/3/24.
//

import SwiftUI
import MarkdownUI
import Supabase

private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)

struct AddNotesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var userNote = ""
    var note: Note
    
    var body: some View {
        NavigationStack {
            VStack {
                Markdown("> \(note.passage)")
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
                        saveNote()
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
    
    private func saveNote() {
        Task {
            // Construct note model
            let noteEncodable = NoteCodable(passage: note.passage, userNote: $userNote.wrappedValue, color: note.uiColor.hexString, length: note.length, location: note.location, bibleId: note.bibleId, bibleName: note.bibleName, chapterId: note.chapterId, chapterName: note.chapterName, userUuid: UserDefaults.standard.string(forKey: User.Key.uuid.rawValue)!)
            do {
                let response = try await client.from("Note").insert(noteEncodable).execute()
                print("Add note response: \(response)")
            } catch {
                print("Save note error: \(error)")
            }
        }
    }
}

//#Preview {
//    AddNotesView()
//}
