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
    //MARK: Data in
    let matches: [Match]
    
    var capacity: Int {
            matches.count > 4 ? 6 : 4
        }

    //MARK - Body
    var body: some View {
        let columnCount = (capacity + 1) / 2
                
                HStack {
                    ForEach(0..<columnCount, id: \.self) { column in
                        VStack {
                            matchMarkers(peg: column * 2)
                            matchMarkers(peg: column * 2 + 1)
                        }
                    }
                }
            }
    
    func matchMarkers(peg: Int) -> some View {
        let exactCount: Int = matches.count { $0 == .exact}
        let foundCount: Int = matches.count { $0 != .nomatch}
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}



struct fakeView: View {
    var body: some View {
        VStack {
            Dummypegs(matches: [.exact, .inexact , .inexact])
            Dummypegs(matches: [.exact, .nomatch , .nomatch])
            Dummypegs(matches: [.exact, .exact , .inexact, .inexact])
            Dummypegs(matches: [.exact, .exact , .inexact, .inexact, .inexact])
            Dummypegs(matches: [.exact, .exact , .inexact, .inexact, .inexact,.exact])
            Dummypegs(matches: [.exact, .nomatch , .nomatch, .nomatch, .nomatch,.nomatch])
        }
        .padding()
        
    }
    
    func Dummypegs(matches: [Match]) -> some View {
        HStack{
            ForEach(0..<matches.count,id: \.self) {_ in
                Circle().frame(width: 40,height: 60)
            }
            MatchMarkers(matches:matches).frame(width: 40,height: 60)
            
            Spacer()
        }
    }
}

#Preview {
    fakeView()
}
