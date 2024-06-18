//
//  BibleView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import SwiftUI

struct BibleView: View {
    
    @StateObject private var bibleObservable = BibleObservable()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(bibleObservable.arrayBibles) { bible in
                    NavigationLink {
                        BooksView(bible: bible)
                            .environmentObject(bibleObservable)
                    } label: {
                        VStack {
                            Text(bible.name)
                        }
                    }
                }
            }
            .navigationTitle("Bibles")
        }
        .task {
            do {
                try await bibleObservable.getBibles()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    BibleView()
}
