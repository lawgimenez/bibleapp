//
//  HighlightOptionView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/22/24.
//

import SwiftUI

struct HighlightOptionView: View {
    
    @Binding var highlightsColor: [Highlights]
    @Binding var selectedColor: Highlights
    @Binding var addedHighlight: Bool
    
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
                            addedHighlight = true
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
