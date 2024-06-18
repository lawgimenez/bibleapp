//
//  Chapter.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

struct Chapter: Decodable {
    
    var data: [Data]
    
    struct Data: Decodable, Identifiable {
        
        var id: String
        var bibleId: String
        var number: String
        var bookId: String
        var content: String
        var reference: String
        var verseCount: Int
        var next: Verse
        var previous: Verse
        
        struct Verse: Decodable, Identifiable {
            
            var id: String
            var bookId: String
            var number: String
        }
    }
}
