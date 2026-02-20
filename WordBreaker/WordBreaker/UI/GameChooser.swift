//
//  GameChooser.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/19.
//

import SwiftUI

struct GameChooser: View {
    
    @State private var games: [WordBreaker] = []
    @State private var nextGameNumber = 1
    
    var sortedGames: [WordBreaker] {
            games.sorted(by: { $0.lastPlayed > $1.lastPlayed })
        }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(sortedGames) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                }
                .onDelete{ offsets in
                    for index in offsets {
                    let gameToDelete = sortedGames[index]
                    if let originalIndex = games.firstIndex(where: { $0.id == gameToDelete.id }) {
                        games.remove(at: originalIndex)
                    }
                }
                }
                .onMove{ offsets, destination in
                    games.move(fromOffsets: offsets, toOffset:destination)
                }
            }
            .navigationDestination(for: WordBreaker.self) { game in
                WordsView(game: game)
            }
            .listStyle(.plain)
            .toolbar{
                EditButton()
            }
            Button("New Game") {
                createnewgame()
            }
        }
    }
    
    func createnewgame() {
        let newName = "WordGame \(nextGameNumber)"
        let randomLength = [3, 4, 5, 6].randomElement() ?? 4
        games.append(WordBreaker(name: newName, length: randomLength))
        nextGameNumber += 1
    }
}

#Preview {
    GameChooser()
}

