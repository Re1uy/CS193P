//
//  ContentView.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/9.
//

import SwiftUI

struct CodeBreakerView: View {
    
    //MARK: Data Owned by Me
    @State private var game = CodeBreaker(ColorChoice: ["red", "blue", "yellow", "green", "black"], EmojiChoice: ["🌍", "🐔", "😊", "🤔"])
    
    @State private var selection: Int = 0
    //MARK - Body
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView{
                if !game.isOver {
                    view(for: game.guess)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            PegChooser(supportColors: game.SupportColor,choices: game.pegChoices) { peg in game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
            restartButton
        }
        .padding()
    }

    var guessButton: some View {
        Button("Guess") {
            if game.AllowGuess() {
                withAnimation{
                    game.attemptGuess()
                    selection = 0
                }
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    var restartButton: some View {
        Button("Restart Game"){
            game.restartgame()
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, supportColors: game.SupportColor, selection: $selection)
            MatchMarkers(matches: code.matches ?? [])
                .overlay{
                    if code.kind == .guess{
                        guessButton
                    }
                }
        }
    }
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
