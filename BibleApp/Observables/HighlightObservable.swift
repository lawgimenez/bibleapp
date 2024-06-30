//
//  HighlightObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/27/24.
//

import Foundation
import Supabase
import UIKit
import SwiftUI
import SwiftData

class HighlightObservable: ObservableObject {
    
    private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)
    private var modelContext: ModelContext?
    
    enum Status {
        case inProgress
        case none
    }
    
    @Published var addHighlightStatus: Status = .none
    
//    func addHighlight(highlight: Highlight) async throws {
//        // JSON body missing User ID
//        let json = [
//            Highlight.Key.passage.rawValue: highlight.passage,
//            Highlight.Key.color.rawValue: highlight.color.description,
//            Highlight.Key.length.rawValue: highlight.length,
//            Highlight.Key.location.rawValue: highlight.location,
//            Highlight.Key.bibleId.rawValue: highlight.bibleId,
//            Highlight.Key.bibleName.rawValue: highlight.bibleName,
//            Highlight.Key.chapterId.rawValue: highlight.chapterId,
//            Highlight.Key.chapterName.rawValue: highlight.chapterName
//        ] as [String: Any]
//        let url = URL(string: Urls.Api.highlight)
//        let session = URLSession.shared
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Bearer \(Urls.supabaseApiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue(Urls.supabaseApiKey, forHTTPHeaderField: "apikey")
//    }
    
    func setModelContext(_ modelContext: ModelContext) {
        print("Set model context")
        self.modelContext = modelContext
    }
    
    func getHighlights(userUuid: String) async throws {
        let highlights: [HighlightDecodable] = try await client.from("Highlight").select().eq(HighlightDecodable.CodingKeys.userUuid.rawValue, value: userUuid).execute().value
        for highlight in highlights {
            let highlight = Highlight(id: highlight.id, passage: highlight.passage, location: highlight.location, length: highlight.length, bibleId: highlight.bibleId, bibleName: highlight.bibleName, chapterId: highlight.chapterId, chapterName: highlight.chapterName, color: Color(uiColor: UIColor(hexString: highlight.color)))
            // Save to database
            modelContext?.insert(highlight)
            try modelContext?.save()
        }
    }
    
    func deleteHighlight(highlight: Highlight) async throws {
        let deleteResponse = try await client.from("Highlight").delete().eq("id", value: highlight.id).execute()
        modelContext?.delete(highlight)
    }
}
