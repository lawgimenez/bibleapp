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
                let _ = print("highlight \(highlight.bibleName)")
                VStack(alignment: .leading) {
                    Text(highlight.passage)
                    Spacer()
                    Text(highlight.bibleName)
                    Text(highlight.chapterName)
                }
                .listRowBackground(highlight.color)
                .padding()
            }
            .navigationTitle("Highlights")
        }
    }
}

#Preview {
    HighlightsView()
}
