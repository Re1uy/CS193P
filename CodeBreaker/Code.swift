//
//  Code.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/15.
//

import SwiftUI

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: CodeBreaker.pegNumber)
    
    static let missingPeg: Peg = "clear"
    
    enum Kind: Equatable{
        case master(isHidden:Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        var index : Int = 0
        while index < CodeBreaker.pegNumber {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
            index += 1
        }
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    mutating func reset() {
        pegs = Array(repeating: Code.missingPeg, count: pegs.count)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
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
