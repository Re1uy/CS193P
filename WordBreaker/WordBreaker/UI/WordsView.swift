//
//  WordsView.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/16.
//

import SwiftUI

struct WordsView: View {
    @Environment(\.words) var words
    
    @State private var selection: Int = 0
    let game: WordBreaker


    var body: some View {
        VStack{
            rowView(
                word: game.masterCode,
                editable: false,
                matches: []
            )
            .task(id: words.count) {
                        guard words.count > 0 else { return }
                if game.masterCode.contains(" ") || game.masterCode == "NONE" {
                    game.restartGame(with: words.random(length: game.length) ?? "none")
                }
            }
            ScrollView{
                if !game.isOver {
                    rowView(word: game.guessWord, editable: true, matches: [])
                    
                }
                ForEach(game.attempts.indices.reversed(),id:\.self) { index in
                    let a = game.attempts[index]
                    rowView(word: a.word, editable: false, matches: a.matches)
                    .animation(.default, value: game.attempts.count)
                }
            }
            
            WordChooser(choices: Array("QWERTYUIOP")) { letter in
                game.setGuessPeg(letter, at: selection)
                selection = (selection + 1) % game.masterCode.count
            }
            WordChooser(choices: Array("ASDFGHJKL")) { letter in
                game.setGuessPeg(letter, at: selection)
                selection = (selection + 1) % game.masterCode.count
            }
            WordChooser(choices: Array("ZXCVBNM")) { letter in
                game.setGuessPeg(letter, at: selection)
                selection = (selection + 1) % game.masterCode.count
            }
            
            if !game.isOver {
                HStack {
                    guessButton
                }
            }
        }
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
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 5
        static let maximumFontSize: CGFloat = 30
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    
    func rowView(word: Word, editable: Bool, matches: [Match]) -> some View {
        HStack {
            view(for: word, editable: editable, matches: matches)
        }
    }
    
    func bgColor(editable: Bool, selected: Bool, matches: [Match], i: Int) -> Color {
        if editable && selected { return Color.gray(0.85) }

        guard matches.indices.contains(i) else { return .clear }

        switch matches[i] {
        case .exact:   return Color.green(0.85)
        case .inexact: return Color.yellow(0.85)
        case .nomatch: return .clear
        }
    }
    
    func view(for word: Word, editable: Bool, matches: [Match]) -> some View {
        let total = game.masterCode.count
        let chars = Array(word)
        
        return HStack(spacing: 10) {
            ForEach(0..<total, id: \.self) { i in
                Text(i < chars.count ? String(chars[i]) : "")
                    .font(.system(size: 40, weight: .bold))
                    .frame(width: 55, height: 55)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(bgColor(editable: editable,
                                          selected: selection == i,
                                          matches: matches,
                                          i: i))
                            
                    }
                    .animation(.easeInOut(duration: 1),
                               value: matches.indices.contains(i) ? matches[i] : .nomatch)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if word == game.guessWord {
                            selection = i
                        }
                }.animation(.easeInOut(duration: 0.15), value: selection)
            }
        }
    }
}



extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
    static func green(_ brightness: CGFloat) -> Color {
        return Color(hue: 120/360, saturation: 0.65, brightness: brightness)
    }
    static func yellow(_ brightness: CGFloat) -> Color {
        return Color(hue: 55/360, saturation: 0.65, brightness: brightness)
    }
}
#Preview {
    WordsView(game: WordBreaker())
}
