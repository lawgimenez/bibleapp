//
//  HighlightObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/27/24.
//

import Foundation
import Supabase

class HighlightObservable: ObservableObject {
    
    private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)
    
    enum Status {
        case inProgress
        case none
    }
    
    @Published var addHighlightStatus: Status = .none
    
    func addHighlight(highlight: Highlight) async throws {
        // JSON body missing User ID
        let json = [
            Highlight.Key.passage.rawValue: highlight.passage,
            Highlight.Key.color.rawValue: highlight.color.description,
            Highlight.Key.length.rawValue: highlight.length,
            Highlight.Key.location.rawValue: highlight.location,
            Highlight.Key.bibleId.rawValue: highlight.bibleId,
            Highlight.Key.bibleName.rawValue: highlight.bibleName,
            Highlight.Key.chapterId.rawValue: highlight.chapterId,
            Highlight.Key.chapterName.rawValue: highlight.chapterName
        ] as [String: Any]
        let url = URL(string: Urls.Api.highlight)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(Urls.supabaseApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(Urls.supabaseApiKey, forHTTPHeaderField: "apikey")
    }
}
