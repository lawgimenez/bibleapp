//
//  Note.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/3/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Note {
    
    @Attribute(.unique) let id: Int
    let passage: String
    let location: Int
    let length: Int
    var bibleId: String
    var bibleName: String
    var chapterId: String
    var chapterName: String
    @Attribute(.transformable(by: UIColorValueTransformer.self)) var uiColor: UIColor
    var color: Color {
        get {
            .init(uiColor: uiColor)
        }
        set {
            uiColor = .init(newValue)
        }
    }
    
    init(id: Int, passage: String, location: Int, length: Int, bibleId: String, bibleName: String, chapterId: String, chapterName: String, uiColor: UIColor) {
        self.id = id
        self.passage = passage
        self.location = location
        self.length = length
        self.bibleId = bibleId
        self.bibleName = bibleName
        self.chapterId = chapterId
        self.chapterName = chapterName
        self.uiColor = uiColor
    }
    
}
