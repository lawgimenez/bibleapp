//
//  NoteDecodable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/4/24.
//

import Foundation

struct NoteDecodable: Decodable {

    let id: Int
    let passage: String
    let userNote: String
    let color: String
    let length: Int
    let location: Int
    let bibleId: String
    let bibleName: String
    let chapterId: String
    let chapterName: String
    let userUuid: String

    enum CodingKeys: String, CodingKey {
        case id
        case passage
        case userNote = "user_note"
        case color
        case length
        case location
        case bibleId = "bible_id"
        case bibleName = "bible_name"
        case chapterId = "chapter_id"
        case chapterName = "chapter_name"
        case userUuid = "user_uuid"
    }
}
