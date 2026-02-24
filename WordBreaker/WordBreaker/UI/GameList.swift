//
//  GameList.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/24.
//

import SwiftUI
import SwiftData

struct GameList: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \WordBreaker.lastPlayed, order: .reverse) private var allGames: [WordBreaker]
    let searchString: String
    
    @State private var currentFilter: GameFilter = .all
    @State private var showingFilterSheet = false

    enum GameFilter: String, CaseIterable, Identifiable {
        case all = "All Games"
        case finished = "Finished"
        case inprogress = "In Progress"
        var id: Self { self }
    }
    
    var filteredGames: [WordBreaker] {
        let statusFilteredGames = allGames.filter { game in
            if currentFilter == .all {
                return true
            }
            if currentFilter == .inprogress {
                return game.attempts != []
            }
            if currentFilter == .finished {
                return game.isOver
            }
            return true
        }

        if searchString.isEmpty {
            return statusFilteredGames
        } else {
            return statusFilteredGames.filter { game in
                let inGuess = game.guessWord.localizedStandardContains(searchString)
                let inAttempts = game.attempts.contains { attempt in
                    attempt.word.localizedStandardContains(searchString)
                }
                return inGuess || inAttempts
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(filteredGames) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        let gameToDelete = filteredGames[index]
                        context.delete(gameToDelete)
                    }
                }
            }
            .listStyle(.plain)
            
            Button("New Game") {
                createNewGame()
            }
            .padding()
        }
        .navigationTitle("Word Breaker")
        .navigationDestination(for: WordBreaker.self) { game in
            WordsView(game: game)
                .navigationTitle(game.name)
                .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingFilterSheet = true
                } label: {
                    let icon = currentFilter == .all ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill"
                    Label("Filter", systemImage: icon)
                }
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            Filter(selectedFilter: $currentFilter)
                .presentationDetents([.medium])
        }
    }
    
    func createNewGame() {
        let newName = "WordGame \(allGames.count + 1)"
        let randomLength = [3, 4, 5, 6].randomElement() ?? 4
        let newGame = WordBreaker(name: newName, length: randomLength)
        context.insert(newGame)
    }
}

#Preview {
    GameChooser()
        .modelContainer(for: WordBreaker.self, inMemory: true)
}
