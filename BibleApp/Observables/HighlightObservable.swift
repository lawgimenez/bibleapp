//
//  HighlightObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/27/24.
//

import Foundation

class HighlightObservable: ObservableObject {
    
    enum Status {
        case inProgress
        case none
    }
    
    @Published var addHighlightStatus: Status = .none
    
    func addHighlight(highlight: Highlight) async throws {
        
    }
}
