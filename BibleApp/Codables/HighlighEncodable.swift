//
//  HighlighEncodable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/28/24.
//

import Foundation

struct HighlighEncodable: Encodable {
    
    let passage: String
    let color: String
    let length: Int
    let location: Int
    let bibleId: String
    let bibleName: String
    let chapterId: String
    let chapterName: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
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
}
