//
//  ChapterView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI

struct ChapterView: View {
    
    var chapters: [Book.Data.Chapters]
    
    var body: some View {
        NavigationStack {
            VStack {
                List(chapters) { chapter in
                    VStack {
                        Text(chapter.number)
                        Text(chapter.reference)
                    }
                }
            }
        }
    }
}

//#Preview {
//    ChapterView()
//}
