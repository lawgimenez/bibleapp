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
    @Environment(\.modelContext) private var modelContext
    @StateObject private var highlightObservable = HighlightObservable()

    var body: some View {
        NavigationStack {
            List(highlights) { highlight in
                HighlightsRowView(highlight: highlight)
                    .listRowBackground(highlight.color)
                    .swipeActions(edge: .trailing) {
                        Button {
                            Task {
                                try await highlightObservable.deleteHighlight(highlight: highlight)
                            }
                        } label: {
                            Label("Delete Highlight", systemImage: "trash")
                                .tint(.red)
                        }
                    }
            }
            .navigationTitle("Highlights")
        }
        .onAppear {
            highlightObservable.setModelContext(modelContext)
        }
    }
}

#Preview {
    HighlightsView()
}
