//
//  ContentView.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/9.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(ColorChoice: ["red", "blue", "yellow", "green"], EmojiChoice: ["🌍", "🐔", "😊", "🤔"])
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            ScrollView{
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
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
                }
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var restartButton: some View {
        Button("Restart Game"){
            game.restartgame()
        }
    }
    
    func color(for pegName: String) -> Color {
        switch pegName {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "yellow": return .yellow
        case "orange": return .orange
        case "brown": return .brown
        case "pink": return .pink
        case "black": return .black
        case "white": return .white
        case "silver": return .gray
        default: return .clear
        }
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id:\.self) { index in
                let peg = code.pegs[index]
                let isColorPeg = CodeBreaker.isColor(in: [peg], check: game.SupportColor)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(isColorPeg ? color(for: peg) : Color.clear)
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .overlay {
                        if !isColorPeg && peg != Code.missing {
                            Text(peg)
                                .font(.system(size: 100))
                                .minimumScaleFactor(9/120)
                                .frame(maxWidth: .infinity, maxHeight:  .infinity)
                                .foregroundStyle(.primary)
                        }
                    }
                    .contentShape(Rectangle())
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            
            MatchMarkers(matches: code.matches)
                .overlay{
                    if code.kind == .guess{
                        guessButton
                    }
                }
        }
    }
}

#Preview {
    CodeBreakerView()
}
