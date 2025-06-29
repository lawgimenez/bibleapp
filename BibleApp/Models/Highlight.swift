//
//  Highlight.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/20/24.
//

import Foundation
import SwiftData
import UIKit
import SwiftUI

@Model
class Highlight {

    enum Key: String {
        case passage
        case color
        case length
        case location
        case bibleId = "bible_id"
        case bibleName = "bible_name"
        case chapterId = "chapter_id"
        case chapterName = "chapter_name"
        case userId = "user_id"
    }

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

    init(id: Int, passage: String, location: Int, length: Int, bibleId: String, bibleName: String, chapterId: String, chapterName: String, color: Color) {
        self.id = id
        self.passage = passage
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
