//
//  BibleData.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/21/24.
//

import SwiftData

@Model
class BibleData {
    
    @Attribute(.unique) let id: String
    let dblId: String
    let abbreviation: String
    let abbreviationLocal: String
    let name: String
    let nameLocal: String
    let desc: String
    let descriptionLocal: String
    let type: String
    
    init(id: String, dblId: String, abbreviation: String, abbreviationLocal: String, name: String, nameLocal: String, description: String, descriptionLocal: String, type: String) {
        self.id = id
        self.dblId = dblId
        self.abbreviation = abbreviation
        self.abbreviationLocal = abbreviationLocal
        self.name = name
        self.nameLocal = nameLocal
        self.desc = description
        self.descriptionLocal = descriptionLocal
        self.type = type
    }
}
