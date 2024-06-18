//
//  Section.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

struct Section: Decodable {
    
    var data: [Data]
    
    struct Data: Decodable, Identifiable {
        
        var id: String
        var bibleId: String
        var bookId: String
        var title: String
        var firstVerseId: String
        var lastVerseId: String
        var firstVerseOrgId: String
        var lastVerseOrgId: String
    }
}
