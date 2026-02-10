//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/9.
//


import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    var matches: [Match]
    
    var body: some View {
        HStack {
            VStack {
                matchMarkers(peg: 0)
                matchMarkers(peg: 1)
            }
            VStack {
                matchMarkers(peg: 2)
                matchMarkers(peg: 3)
            }
        }
    }
    
    func matchMarkers(peg: Int) -> some View {
        let exactCount: Int = matches.count(where: { match in match == .exact})
        let foundCount: Int = matches.count(where: { match in match != .nomatch})
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
    
    
    
    
    
    
}

#Preview {
    MatchMarkers(matches: [.exact,.exact,.inexact,.exact]
    )
}
