//
//  AddNotesView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 7/3/24.
//

import SwiftUI

struct AddNotesView: View {
    
    var note: Note
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(">\(note.passage)")
            }
            .navigationTitle("Add Notes")
        }
    }
}

//#Preview {
//    AddNotesView()
//}
