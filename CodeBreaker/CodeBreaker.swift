//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/14.
//

import SwiftUI

typealias Peg = String

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    var ColorChoice: [Peg]
    var EmojiChoice: [Peg]
    var pegChoices: [Peg]
    let SupportColor: [Peg] = ["red", "green", "blue", "yellow", "brown", "orange"
                               , "pink", "black", "white", "silver"]
    static let NumberChoices = [3, 4, 5, 6]
    static var pegNumber: Int = CodeBreaker.NumberChoices.randomElement() ?? 4
    
    init(ColorChoice: [Peg] = ["red", "green", "blue", "yellow"], EmojiChoice:[Peg] = ["🌍", "🐔", "😊", "🤔"]) {
        self.ColorChoice = ColorChoice
        self.EmojiChoice = EmojiChoice
        self.pegChoices = Bool.random() && CodeBreaker.isColor(in: ColorChoice, check: SupportColor) ? ColorChoice : EmojiChoice
        masterCode.randomize(from: pegChoices)
        print(masterCode)
        print(pegChoices)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else {return}
        guess.pegs[index] = peg
    }
    
    static func isColor(in Choices: [Peg], check Support: [Peg]) -> Bool {
        !Choices.contains{ color in
            !Support.contains(color)
        }
    }
    
    func AllowGuess() -> Bool {
        !(attempts.contains { attempt in
            attempt.pegs == guess.pegs})
        &&
        guess.pegs.contains{peg in pegChoices.contains(peg)}
    }
    
    mutating func restartgame() {
        CodeBreaker.pegNumber = CodeBreaker.NumberChoices.randomElement() ?? 4
        guess.pegs = Array(repeating: Code.missingPeg, count:CodeBreaker.pegNumber)
        attempts = []
        masterCode = Code(kind: .master(isHidden: true))
        pegChoices = Bool.random() && CodeBreaker.isColor(in: ColorChoice, check: SupportColor) ? ColorChoice : EmojiChoice
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}




