//
//  PassageData.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/21/24.
//

import SwiftData

@Model
class PassageData {
    
    @Attribute(.unique) let id: String
    let orgId: String
    let bibleId: String
    let bookId: String
    let reference: String
    let content: String
    let copyright: String
    
    init(id: String, orgId: String, bibleId: String, bookId: String, reference: String, content: String, copyright: String) {
        self.id = id
        self.orgId = orgId
        self.bibleId = bibleId
        self.bookId = bookId
        self.reference = reference
        self.content = content
        self.copyright = copyright
    }
}
