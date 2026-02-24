//
//  GameChooser.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/19.
//

import SwiftUI
import SwiftData

struct GameChooser: View {
    
    
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var search: String = ""
    
    var body: some View {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                GameList(searchString: search)
                    .navigationTitle("Word Breaker")
                    .searchable(text: $search,
                                placement: .navigationBarDrawer(displayMode: .always),
                                prompt: "Search guesses & attempts")
            } detail: {
                Text("Select a game")
            }
        }
}

#Preview {
    GameChooser()
        .modelContainer(for: WordBreaker.self, inMemory: true)
}

