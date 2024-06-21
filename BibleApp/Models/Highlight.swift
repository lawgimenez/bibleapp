//
//  Highlight.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/20/24.
//

import Foundation

class Highlight {
    
    private var passage: String
    private var range: NSRange
    
    init(passage: String, range: NSRange) {
        self.passage = passage
        self.range = range
    }
    
    func getRange() -> NSRange {
        return range
    }
}
