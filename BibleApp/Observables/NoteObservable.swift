//
//  NoteObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/4/24.
//

import Foundation
import Supabase
import UIKit
import SwiftUI
import SwiftData

@MainActor
class NoteObservable: ObservableObject {
    
    enum AddNoteStatus {
        case none
        case inProgress
        case success
        case failed
    }
    
    private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)
    private var modelContext: ModelContext?
    @Published var addNoteStatus: AddNoteStatus = .none
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getNotes(userUuid: String) async throws {
        let notes: [NoteDecodable] = try await client.from("Note").select().eq(NoteDecodable.CodingKeys.userUuid.rawValue, value: userUuid).execute().value
        print("Notes found: \(notes.count)")
        for note in notes {
            let note = Note(id: note.id, passage: note.passage, userNote: note.userNote, location: note.location, length: note.length, bibleId: note.bibleId, bibleName: note.bibleName, chapterId: note.chapterId, chapterName: note.chapterName, color: Color(uiColor: UIColor(hexString: note.color)))
            // Save to database
            modelContext?.insert(note)
            try modelContext?.save()
        }
    }
    
    func saveNote(noteEncodable: NoteEncodable) async throws {
        let response = try await client.from("Note").insert(noteEncodable).execute()
        print("Add note response: \(response)")
        if response.status == 201 {
            addNoteStatus = .success
        } else {
            addNoteStatus = .failed
        }
    }
    
    func deleteNote(note: Note) async throws {
        try await client.from("Note").delete().eq("id", value: note.id).execute()
        modelContext?.delete(note)
    }
}
