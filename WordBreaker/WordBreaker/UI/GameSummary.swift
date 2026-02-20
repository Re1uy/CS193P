//
//  GameSummary.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/19.
//

import SwiftUI

struct GameSummary: View {
    
    
    let game: WordBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            if let lastAttempt = game.attempts.last {
                AttemptView(word: lastAttempt.word,
                            matches: lastAttempt.matches,
                            total: game.length,Over: game.isOver)
            } else {
                AttemptView(word: "", matches: [], total: game.length,Over:game.isOver)
            }
            HStack{
                Text("^[\(game.attempts.count) attempt](inflect:true)")
                Spacer()
                if game.isOver {
                    Text("Win!")
                }
            }
        }
    }
}

#Preview {
    List {
        GameSummary(game:WordBreaker(name: "Preview"))
    }
    List {
        GameSummary(game:WordBreaker(name: "Preview"))
    }
    .listStyle(.plain)
}
