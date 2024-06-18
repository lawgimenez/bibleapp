//
//  Book.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

struct Book: Decodable {
    
    struct Data: Decodable, Identifiable {
        
        var id: String
        var bibleId: String
        var abbreviation: String
        var name: String
        var nameLong: String
        var chapters: [Chapters]
        
        struct Chapters: Decodable, Identifiable {
            
            var id: String
            var bibleId: String
            var number: String
            var bookId: String
            var reference: String
        }
    }
}
