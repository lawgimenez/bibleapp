//
//  HighlightsRowView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/30/24.
//

import SwiftUI

struct HighlightsRowView: View {

    var highlight: Highlight

    var body: some View {
        VStack(alignment: .leading) {
            Text(highlight.passage)
            Spacer()
            HStack {
                Image(systemName: "book.circle")
                Text(highlight.bibleName)
            }
            Text(highlight.chapterName)
        }
        .padding()
    }
}

// #Preview {
//    HighlightsRowView()
// }
