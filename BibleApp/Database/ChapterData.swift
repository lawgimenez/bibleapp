//
//  ChapterData.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/21/24.
//

import SwiftData

@Model
class ChapterData {
    
    let id: String
    let bibleId: String
    let number: String
    let bookId: String
    let content: String
    let reference: String
    let verseCount: Int
    
    init(id: String, bibleId: String, number: String, bookId: String, content: String, reference: String, verseCount: Int) {
        self.id = id
        self.bibleId = bibleId
        self.number = number
        self.bookId = bookId
        self.content = content
        self.reference = reference
        self.verseCount = verseCount
    }
}
