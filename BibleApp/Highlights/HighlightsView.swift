//
//  HighlightsView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/24/24.
//

import SwiftUI
import SwiftData

struct HighlightsView: View {
    
    @Query private var highlights: [Highlight]
    
    var body: some View {
        NavigationStack {
            List(highlights) { highlight in
                HighlightsRowView(highlight: highlight)
                    .listRowBackground(highlight.color)
            }
            .navigationTitle("Highlights")
        }
    }
}

#Preview {
    HighlightsView()
}
