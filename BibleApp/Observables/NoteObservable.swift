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

class NoteObservable: ObservableObject {
    
    private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)
    private var modelContext: ModelContext?
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getNotes(userUuid: String) async throws {
        let notes: [NoteDecodable] = try await client.from("Note").select().eq(NoteDecodable.CodingKeys.userUuid.rawValue, value: userUuid).execute().value
        print("Notes found: \(notes.count)")
        for note in notes {
            let note = Note(id: note.id, passage: note.passage, location: note.location, length: note.length, bibleId: note.bibleId, bibleName: note.bibleName, chapterId: note.chapterId, chapterName: note.chapterName, color: Color(uiColor: UIColor(hexString: note.color)))
            // Save to database
            modelContext?.insert(note)
            try modelContext?.save()
        }
    }
}
