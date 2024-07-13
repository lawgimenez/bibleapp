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
    let userNote: String
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

    init(id: Int, passage: String, userNote: String, location: Int, length: Int, bibleId: String, bibleName: String, chapterId: String, chapterName: String, color: Color) {
        self.id = id
        self.passage = passage
        self.userNote = userNote
        self.location = location
        self.length = length
        self.bibleId = bibleId
        self.bibleName = bibleName
        self.chapterId = chapterId
        self.chapterName = chapterName
        self.uiColor = .init(color)
    }

    func getRange() -> NSRange {
        return NSRange(location: location, length: length)
    }

}
