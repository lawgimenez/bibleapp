//
//  BookData.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/21/24.
//

import SwiftData

@Model
class BookData {

    @Attribute(.unique) let id: String
    var bibleId: String
    let abbreviation: String
    let name: String
    let nameLong: String

    init(id: String, bibleId: String, abbreviation: String, name: String, nameLong: String) {
        self.id = id
        self.bibleId = bibleId
        self.abbreviation = abbreviation
        self.name = name
        self.nameLong = nameLong
    }
}
