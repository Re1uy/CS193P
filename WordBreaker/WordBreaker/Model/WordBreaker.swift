//
//  WordBreaker.swift
//  WordBreaker
//
//  Created by 千秋 on 2026/2/16.
//

import Foundation
import UIKit
import SwiftData


typealias Word = String

@Model class WordBreaker {
    
    var id = UUID()
    var length: Int
    var name:String
    var masterCode: Word = "none"
    @Transient var guess: [Character] {
        get { guessRaw.compactMap { $0.first } }
        set { guessRaw = newValue.map { String($0) } }
    }
    var guessRaw: [String] = []
    var guessWord: Word { String(guess) }
    @Relationship(deleteRule: .cascade) var attempts: [Attempt] = []
    static let NumberChoices = [3, 4, 5, 6]
    
    var lastPlayed: Date = Date()
    
    init(name: String = "Word Breaker", masterCode: Word = "none",length: Int = 4) {
        self.name = name
        self.masterCode = masterCode.uppercased()
        self.length = length
        self.guessRaw = Array(repeating: " ", count: self.masterCode.count)
    }
    
    func setGuessPeg(_ letter: Character, at index: Int) {
        guard guess.indices.contains(index) else {return}
        guess[index] = letter
    }
    
    var isOver: Bool {attempts.contains { attempt in attempt.word == masterCode }}
    
    func AllowGuess() -> Bool {
        return !guess.contains(" ") &&
        !attempts.contains { $0.word == guessWord } &&
        UITextChecker().isAWord(guessWord.lowercased())
    }
    
    func attemptGuess() {
        let attemptword = guessWord
        attempts.append(Attempt(word: attemptword, matches:matches(for: attemptword)))
        lastPlayed = Date()
        reset()
    }
    
    func reset() {
        guessRaw = Array(repeating: " ", count: masterCode.count)
    }
    
    func matches(for word: Word) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: masterCode.count)
        let wordToMatch = Array(word)
        var wordneedMatch = Array(masterCode)
        
        for index in wordToMatch.indices.reversed() {
            if wordneedMatch.count > index, wordToMatch[index] == wordneedMatch[index] {
                results[index] = .exact
                wordneedMatch.remove(at: index)
            }
        }
        
        for index in wordToMatch.indices {
            if results[index] != .exact {
                if let matchIndex = wordneedMatch.firstIndex(of: wordToMatch[index]) {
                    results[index] = .inexact
                    wordneedMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
    
    func restartGame(with newCode: String) {
        self.masterCode = newCode.uppercased()
        self.length = newCode.count
        self.attempts = []
        self.reset()
    }
}

@Model class Attempt: Identifiable {
    var id = UUID()
    var word: Word
    var matchRawValues: [String] = []
    
    @Transient var matches: [Match] {
        get { matchRawValues.compactMap { Match(rawValue: $0) } }
        set { matchRawValues = newValue.map { $0.rawValue } }
    }
    
    init(id: UUID = UUID(), word: Word, matches: [Match]) {
        self.id = id
        self.word = word
        self.matchRawValues = matches.map { $0.rawValue }
    }
}
