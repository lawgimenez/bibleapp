//
//  MainView.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var bibleObservable = BibleObservable()
    
    var body: some View {
        VStack {
            
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
    MainView()
}
