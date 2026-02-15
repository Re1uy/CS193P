//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/14.
//

import SwiftUI

typealias Peg = String

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master)
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
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
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
        guess.pegs = Array(repeating: Code.missing, count:CodeBreaker.pegNumber)
        attempts = []
        masterCode = Code(kind: .master)
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
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
}

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missing, count: CodeBreaker.pegNumber)
    
    static let missing: Peg = "clear"
    
    enum Kind: Equatable{
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        var index : Int = 0
        while index < CodeBreaker.pegNumber {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
            index += 1
        }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}


