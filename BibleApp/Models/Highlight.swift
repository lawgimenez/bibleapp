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
    
    let passage: String
    let location: Int
    let length: Int
    var bibleId: String
    var chapterId: String
    @Attribute(.transformable(by: UIColorValueTransformer.self)) var uiColor: UIColor
    var color: Color {
        get {
            .init(uiColor: uiColor)
        }
        set {
            uiColor = .init(newValue)
        }
    }
    
    init(passage: String, location: Int, length: Int, bibleId: String, chapterId: String, color: Color) {
        self.passage = passage
        self.location = location
        self.length = length
        self.bibleId = bibleId
        self.chapterId = chapterId
        self.uiColor = .init(color)
    }
    
    func getRange() -> NSRange {
        return NSRange(location: location, length: length)
    }
}
