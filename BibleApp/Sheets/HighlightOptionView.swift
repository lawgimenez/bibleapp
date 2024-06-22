//
//  HighlightOptionView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/22/24.
//

import SwiftUI

struct HighlightOptionView: View {
    
    struct HighlightsColor: Identifiable {
        let id = UUID()
        let color: Color
    }
    
    let highlightsColor = [
        HighlightsColor(color: .highlightPink),
        HighlightsColor(color: .highlightGreen),
        HighlightsColor(color: .highlightGrayish),
        HighlightsColor(color: .highlightLightBlue)
    ]
    
    @State private var selectedColor = HighlightsColor(color: .highlightPink)
    
    var body: some View {
        VStack {
            Text("Highlight Options")
                .font(.largeTitle)
            Divider()
            Text("Choose color")
            HStack {
                ForEach(highlightsColor) { highlightColor in
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(highlightColor.color)
                        .frame(maxWidth: 50, maxHeight: 50)
                        .onTapGesture {
                            selectedColor = highlightColor
                        }
                }
            }
            Spacer()
        }
        .padding(18)
    }
}

//#Preview {
//    HighlightOptionView()
//}
