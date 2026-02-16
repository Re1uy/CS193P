//
//  PegView.swift
//  CodeBreaker
//
//  Created by 千秋 on 2026/2/15.
//

import SwiftUI

struct PegView: View {
    //MARK: Data in
    let peg: Peg
    let supportColors: [Peg]
    
    //MARK: - Body
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
    
    var body: some View {
        
        let isColorPeg = CodeBreaker.isColor(in: [peg], check: supportColors)
        
        let pegShape = RoundedRectangle(cornerRadius: 10)
        
        pegShape
            .fill(isColorPeg ? color(for: peg) : Color.clear)
            .overlay {
                if peg == Code.missingPeg {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray)
                }
            }
            .overlay {
                if !isColorPeg && peg != Code.missingPeg {
                    Text(peg)
                        .font(.system(size: 100))
                        .minimumScaleFactor(9/120)
                        .frame(maxWidth: .infinity, maxHeight:  .infinity)
                        .foregroundStyle(.primary)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    PegView(peg: "blue", supportColors: CodeBreaker().SupportColor)
        .padding()
}
