//
//  Highlight.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/20/24.
//

import Foundation
import SwiftData

@Model
class Highlight {
    
    let passage: String
    let location: Int
    let length: Int
    var bibleId: String
    var chapterId: String
    
    init(passage: String, location: Int, length: Int, bibleId: String, chapterId: String) {
        self.passage = passage
        self.location = location
        self.length = length
        self.bibleId = bibleId
        self.chapterId = chapterId
    }
    
    func getRange() -> NSRange {
        return NSRange(location: location, length: length)
    }
}
