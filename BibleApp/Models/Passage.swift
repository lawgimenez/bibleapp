//
//  Passage.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

struct Passage: Decodable {
    
    var data: Data
    
    struct Data: Decodable, Identifiable {
        
        var id: String
        var orgId: String
        var bibleId: String
        var bookId: String
        var reference: String
        var content: String
        var copyright: String
    }
}
